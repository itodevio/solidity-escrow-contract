// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	bool public isApproved;

	event Approved(uint);

	error Unauthorized();
	error FailedToSendEther();

	modifier onlyArbiter {
		if (msg.sender != arbiter) {
			revert Unauthorized();
		}

		_;
	}

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}


	function approve() external onlyArbiter {
		isApproved = true;
		uint balance = address(this).balance;
		
		emit Approved(balance);
		
		(bool sent, ) = beneficiary.call{value: balance}("");
		if (!sent) {
			revert FailedToSendEther();
		}
	}
}
