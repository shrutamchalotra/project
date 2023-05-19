// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingContract {
    address public lender;
    mapping(address => uint256) public balances;

    event LoanRequested(address borrower, uint256 amount);
    event LoanRepaid(address borrower, uint256 amount);

    constructor() {
        lender = msg.sender;
    }

    function requestLoan(uint256 amount) external {
        require(amount > 0, "Loan amount must be greater than 0");
        require(balances[msg.sender] == 0, "You already have an active loan");

        balances[msg.sender] = amount;

        emit LoanRequested(msg.sender, amount);
    }

    function repayLoan() external payable {
        require(balances[msg.sender] > 0, "You don't have an active loan");
        require(msg.value == balances[msg.sender], "Incorrect loan repayment amount");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(lender).transfer(amount);

        emit LoanRepaid(msg.sender, amount);
    }
}
