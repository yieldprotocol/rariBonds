// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@yield-protocol/utils-v2/contracts/token/ERC20.sol";

contract MockERC20 is ERC20 {
  constructor() ERC20("Mock Token", "MOCK", 18) {
    _mint(msg.sender, 1000 * 1e18);
  }
}
