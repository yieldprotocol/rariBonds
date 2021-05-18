// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../access/Ownable.sol";
import "../token/ERC20.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
import "./IBasicFYToken.sol";

contract BasicFYToken is IBasicFYToken, ERC20, Ownable {
  address private immutable _underlying;
  uint256 private immutable _maturity;

  address public minter;

  constructor(
    address underlying_,
    uint256 maturity_,
    string memory name,
    string memory symbol
  )
    ERC20(name, symbol, 18)
  {
    _underlying = underlying_;
    _maturity = maturity_;
  }

  modifier onlyMinter {
    require(msg.sender == minter);
    _;
  }

  function maturity() external view override returns (uint256) {
    return _maturity;
  }

  // returns whether or not the fyTokens have matured
  function isMature() external view returns (bool) {
    return block.timestamp >= _maturity;
  }

  // Not necessary
  function mature() external override {}

  function mint(address _recipient, uint256 _amount) external override onlyMinter {
    _mint(_recipient, _amount);
  }

  function burn(address _from, uint256 _amount) external override onlyMinter {
    _burn(_from, _amount);
  }

  // burns fyTokens and returns underlying token to the msg.sender
  function redeem(address _recipient, uint256 _amount) external override returns (uint256 redeemAmount) {
    require(block.timestamp >= _maturity, "Immature");

    uint256 underlyingTokensAvailable = ERC20(_underlying).balanceOf(address(this));
    redeemAmount = _amount * underlyingTokensAvailable / _totalSupply;

    _burn(msg.sender, _amount);
    TransferHelper.safeTransfer(_underlying, _recipient, redeemAmount);
  }

  // returns the underlying token address
  function underlying() external view override returns (address) {
    return _underlying;
  }

  function setMinter(address _newMinter) external override onlyOwner {
    minter = _newMinter;
    emit SetMinter(_newMinter);
  }
}
