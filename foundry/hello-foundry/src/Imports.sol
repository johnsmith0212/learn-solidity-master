// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "solmate/tokens/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20("name", "symbol", 18) {}

contract TestOZ is Ownable {}
