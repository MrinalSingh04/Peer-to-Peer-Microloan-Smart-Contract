// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract PeerToPeerMicroloan {
    struct Loan {
        address lender;
        address borrower;
        address tokenAddress;
        uint256 amount;
        uint256 collateral;
        uint256 interestRate;
        uint256 dueDate;
        bool isRepaid;
        bool isClaimed;
    }

    uint256 public loanCounter;
    mapping(uint256 => Loan) public loans;

    event LoanOffered(uint256 loanId, address indexed lender, address token, uint256 amount, uint256 interestRate, uint256 dueDate);
    event LoanTaken(uint256 loanId, address indexed borrower, uint256 collateral);
    event LoanRepaid(uint256 loanId, address indexed borrower, uint256 repaymentAmount);
    event CollateralClaimed(uint256 loanId, address indexed lender, uint256 collateralAmount);

    function offerLoan(address _tokenAddress, uint256 _amount, uint256 _interestRate, uint256 _duration) external {
        require(_amount > 0, "Loan amount must be greater than zero");
        require(_duration > 0, "Duration must be positive");
        IERC20 token = IERC20(_tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");
        loanCounter++;
        loans[loanCounter] = Loan(msg.sender, address(0), _tokenAddress, _amount, 0, _interestRate, block.timestamp + _duration, false, false);
        emit LoanOffered(loanCounter, msg.sender, _tokenAddress, _amount, _interestRate, block.timestamp + _duration);
    }

    function takeLoan(uint256 _loanId, uint256 _collateralAmount) external {
        Loan storage loan = loans[_loanId];
        require(loan.lender != address(0), "Loan does not exist");
        require(loan.borrower == address(0), "Loan already taken");
        require(_collateralAmount >= loan.amount, "Collateral must cover loan amount");
        IERC20 token = IERC20(loan.tokenAddress);
        require(token.transferFrom(msg.sender, address(this), _collateralAmount), "Collateral transfer failed");
        loan.borrower = msg.sender;
        loan.collateral = _collateralAmount;
        require(token.transfer(msg.sender, loan.amount), "Loan transfer failed");
        emit LoanTaken(_loanId, msg.sender, _collateralAmount);
    }

    function repayLoan(uint256 _loanId) external {
        Loan storage loan = loans[_loanId];
        require(msg.sender == loan.borrower, "Only borrower can repay");
        require(!loan.isRepaid, "Loan already repaid");
        uint256 interest = (loan.amount * loan.interestRate) / 100;
        uint256 repaymentAmount = loan.amount + interest;
        IERC20 token = IERC20(loan.tokenAddress);
        require(token.transferFrom(msg.sender, loan.lender, repaymentAmount), "Repayment transfer failed");
        loan.isRepaid = true;
        require(token.transfer(loan.borrower, loan.collateral), "Collateral return failed");
        emit LoanRepaid(_loanId, msg.sender, repaymentAmount);
    }

    function claimCollateral(uint256 _loanId) external {
        Loan storage loan = loans[_loanId];
        require(msg.sender == loan.lender, "Only lender can claim");
        require(!loan.isRepaid, "Loan is repaid");
        require(block.timestamp > loan.dueDate, "Loan not yet due");
        require(!loan.isClaimed, "Collateral already claimed");
        IERC20 token = IERC20(loan.tokenAddress);
        require(token.transfer(loan.lender, loan.collateral), "Collateral transfer failed");
        loan.isClaimed = true;
        emit CollateralClaimed(_loanId, msg.sender, loan.collateral);
    }
}
