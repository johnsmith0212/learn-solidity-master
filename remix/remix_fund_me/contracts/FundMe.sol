// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();
error NotEnoughFunds();
error WithdralFailed();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Not owner");
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    function fund() public payable {
        // require(
        //     msg.value.getConversionRate() > MINIMUM_USD,
        //     "Not Enough Money"
        // );

        if (msg.value.getConversionRate() < MINIMUM_USD) {
            revert NotEnoughFunds();
        }

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            addressToAmountFunded[funders[funderIndex]] = 0;
        }

        funders = new address[](0);

        // transfer
        payable(msg.sender).transfer(address(this).balance);

        // send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Withdraw Failed");
        if (!sendSuccess) {
            revert WithdralFailed();
        }

        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        // require(callSuccess, "Withdraw Failed");
        if (!callSuccess) {
            revert WithdralFailed();
        }
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
