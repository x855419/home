// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AccessControl.sol";
import "./SafeMath.sol";
import "./IERC20.sol";

contract FeeMechanism is AccessControl {

    using SafeMath for uint256;

    uint256 fee = 1;
    uint256 percentage = 100;

    function changeFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function changePercentage(uint256 _percentage) external onlyOwner {
        percentage = _percentage;
    }

    function applyFee(uint256 _amount, bool is_erc20, IERC20 currency) public payable returns (uint256) {
        uint256 value = _amount.mul(fee);
        value = value.div(percentage);
        if (is_erc20) {
            currency.transfer(owner, value);
        } else {
            (bool sent, bytes memory data) = owner.call{value: value}("");
            require(sent, "Failed to send Ether");
        }
        return value;
    }
}