# BSN Spartan Simple-Storage

[![Smart Contract](https://badgen.net/badge/smart-contract/Solidity/orange)](https://soliditylang.org/)

Persistent storage is a major feature of blockchain technology. Data storage in traditional IT systems relies on existing storage resources. Users must either build the hardware by themselves or purchase cloud resources. Moreover, as both storage methods are private, the business data will be lost if the local database is corrupted or if the cloud resource fails to renew. The Public IT System defined by the BSN is based on the technology of Non-Crypto Public Chain. Users only need to bear very little GAS fee to complete deploying contracts and sending transactions. The data will be permanently stored on the chain, and there is no charge for data query.

## Prerequisite

Before using a smart contract, it is important to have a basic understanding of Ethereum and Solidity.

## Overview

This contract allows users to submit business data to the blockchain for storage. You can also delete, modify and query the data. The contract provides only two function: storeData and queryData. The business system can perform different operations on business data by passing in different values when calling the contract.


## Usage

Get the Simple-Storage contract source code by command:

```
$ git clone https://github.com/BSN-Spartan/Simple-Storage-Contract.git
```

After deploying the contract, users can commit business data to the chain and take basic storage functions.

- Store: The business system defines the key, and input the business data as value. Then call "storeData" function to commit the data to the chain.
- Delete: Specify the key of the business data to be deleted in the business system, and leave the value blank. Then call "storeData" function to delete the original data.
- Update: Specify the key of the business data to be updated in the business system, and input the new business data as value. Then, call "storeData" function to update the data.
- Query: Specify the key of the business data to be queried in the business system, and call "queryData" function to find out the business data stored on the chain.

## Main Functions

### storeData

```
function storeData(string memory key, string memory value) public
```

Users can use this function to store, delete and update the data. The result can be found by calling queryData function.


### queryData

```
function queryData(string memory key) public view returns (string memory)
```

Returns the latest data corresponding to the given key.

## License

Spartan Simple-Storage Contracts is released under the [Spartan License](https://github.com/BSN-Spartan/Beginner-Level-Contracts/blob/main/Spartan%20License.md).
