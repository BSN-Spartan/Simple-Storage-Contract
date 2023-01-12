// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    event StoreData(string key, string value);
    mapping(string => string) private _keyValues;

    function storeData(string memory key, string memory value) public {
        _keyValues[key] = value;
        emit StoreData(key, value);
    }

    function queryData(string memory key) public view returns (string memory) {
        return _keyValues[key];
    }
}
