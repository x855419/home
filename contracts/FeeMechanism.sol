// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./AccessControl.sol";
import "./SafeMath.sol";

contract FeeMechanism is AccessControl {

    using SafeMath for uint256;

    uint256 fee = 3;
    uint256 percentage = 1000;

    function changeFee(uint32 _fee) external onlyOwner {
        fee = _fee;
    }

    function changePercentage(uint32 _percentage) external onlyOwner {
        percentage = _percentage;
    }

    function applyFee(uint256 _amount) external payable returns (uint256) {
        uint256 value = _amount.mul(fee);
        value = value.div(percentage);
        (bool sent, bytes memory data) = getOwner().call{value: value}("");
        require(sent, "Failed to send Ether");   
        return value;
    }
}