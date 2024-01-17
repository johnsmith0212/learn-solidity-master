// SPDX-License-Identifier: MIT

// Solidity 版本
pragma solidity ^0.8.8;

// 引入合约/库
import "./PriceConverter.sol";
import "hardhat/console.sol";

// 错误码
error FundMe__NotOwner();
error FundMe__NotEnoughFunds();
error FundMe__WithdralFailed();

// 接口、库、合约

// 必要注释以自动生成文档
/** @title A contract for crowd funding
 *   @author Yu ZHANG
 *   @notice This contract is a demo for a sample funding contracts
 *   @dev This implements price feeds as our library
 */
contract FundMe {
    // 声明类型
    using PriceConverter for uint256;

    // 状态变量
    uint256 public constant MINIMUM_USD = 50 * 1e10;
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    // 事件

    // 函数修饰符
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Not owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    // 函数顺序
    // 1. constructor
    // 2. receive
    // 3. fallback
    // 4. external
    // 5. public
    // 6. internal
    // 7. private
    // 8. view / pure

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     *   @notice This fuction is used to receive funds from participants
     *   @dev This implements price feeds as our library
     */
    function fund() public payable {
        // require(
        //     msg.value.getConversionRate() > MINIMUM_USD,
        //     "Not Enough Money"
        // );

        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) {
            revert FundMe__NotEnoughFunds();
        }
        // console.log(">>> MINIMUM_USD:", MINIMUM_USD);
        // console.log(">>> Funding:", msg.value.getConversionRate(s_priceFeed));

        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public payable onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            s_addressToAmountFunded[s_funders[funderIndex]] = 0;
        }

        s_funders = new address[](0);

        // transfer
        payable(msg.sender).transfer(address(this).balance);

        // send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Withdraw Failed");
        if (!sendSuccess) {
            revert FundMe__WithdralFailed();
        }

        // call
        (bool callSuccess, ) = i_owner.call{value: address(this).balance}("");
        // require(callSuccess, "Withdraw Failed");
        if (!callSuccess) {
            revert FundMe__WithdralFailed();
        }
    }

    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess, ) = i_owner.call{value: address(this).balance}("");

        if (!callSuccess) {
            revert FundMe__WithdralFailed();
        }
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address funder)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
