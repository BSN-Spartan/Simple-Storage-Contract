# Simple-Storage Contract

Permanent storage is a major feature of blockchain technology. Data storage in traditional IT systems relies on existing storage resources. Users must either build the space by themselves or purchase cloud resources. Plus, as both storage methods are private, the business data will be lost if the local database is corrupted or if the cloud resource is not renewed. The Public IT System defined by the BSN has the characteristics of the Non-Crypto Public Chain. Users only need to bear very little GAS fee to complete deploying contracts and sending transactions. The data will be permanently stored on the chain, and there is no charge for data query.

## 1. Instructions
* The data submitted by the user is publicly available. If the business data involves sensitive information, you need to encrypt the plaintext data into ciphertext data before sending the transaction. After calling the query method to obtain the ciphertext data from the chain, you may decrypt it locally to ensure the safety of the original plaintext data.

* The GAS fee incurred by a transaction is related to the size of the data in the transaction. Users can reduce the GAS fee by compressing the data before sending it to the chain.

## 2. Contract Overview
By calling this contract, users can submit their business data to the blockchain for storage, deletion, modification and query. The contract only contains two methods, storeData and queryData. 

* Store Data: the key value can be customized in the business system. Users can use the business data as value, and call storeData method to submit the data to the chain.
* Delete Data: Specify the key value in the business system, use an empty string as the value, and call storeData method to act as data deletion.
* Modify Data: Specify the key value in the business system, use the new business data as the value, and call storeData method to complete the data modification.
* Query Data: Specify the key value in the business system, call queryData method to find the business data stored on the chain.

## 3. Contract Method

No.  |  Method Declaration   |  Description 
----|----|----
1 | *storeData(string memory key, string memory value) public* |      Operate business data in the form of key-value pairs            
2 | *queryData(string memory key) public view returns (string memory)* |      Get the business data by the key     


## 4. Call Example by Golang

### 1) Submit Data to the Chain
```
func TestStoreData(t *testing.T) {
    cli, err := ethclient.Dial(NodeUrl)
    if err != nil {
        log.Logger.Error(err)
    }
    instance, err := storage.NewStorage(common.HexToAddress(Address), cli)
    if err != nil {
        log.Logger.Error(err)
    }
    auth, err := eth.GenAuth(cli, PrivateKey)
    if err != nil {
        log.Logger.Error(err)
    }
    tx, err := instance.StoreData(auth, key1, value1)
    if err != nil {
        log.Logger.Error(err)
    }
    fmt.Println("tx Hash:", tx.Hash().String())
}
```

### 2) Delete Data

```
func TestDeleteData(t *testing.T) {
    cli, err := ethclient.Dial(NodeUrl)
    if err != nil {
        log.Logger.Error(err)
    }
    instance, err := storage.NewStorage(common.HexToAddress(Address), cli)
    if err != nil {
        log.Logger.Error(err)
    }
    auth, err := eth.GenAuth(cli, PrivateKey)
    if err != nil {
        log.Logger.Error(err)
    }
    tx, err := instance.StoreData(auth, key1, "")
    if err != nil {
        log.Logger.Error(err)
    }
    fmt.Println("tx Hash:", tx.Hash().String())
}
```

### 3) Modify Data

```
func TestUpdateData(t *testing.T) {
    cli, err := ethclient.Dial(NodeUrl)
    if err != nil {
        log.Logger.Error(err)
    }
    instance, err := storage.NewStorage(common.HexToAddress(Address), cli)
    if err != nil {
        log.Logger.Error(err)
    }
	value, err := instance.QueryData(nil, key1)
    if err != nil {
        log.Logger.Error(err)
    }
	if value == "" {
		log.Logger.Error(errors.New("key1 has no corresponding value in the contract and will not be an update operation"))
	}
	if value == value2 {
		log.Logger.Error(errors.New("the value2 to be updated is the same as the existing value, no update is required"))
	}
    auth, err := eth.GenAuth(cli, PrivateKey)
    if err != nil {
        log.Logger.Error(err)
    }
    tx, err := instance.StoreData(auth, key1, value2)
    if err != nil {
        log.Logger.Error(err)
    }
    fmt.Println("tx Hash:", tx.Hash().String())
}
```

### 4) Query Data
```
func TestQueryData(t *testing.T) {
    cli, err := ethclient.Dial(NodeUrl)
    if err != nil {
        log.Logger.Error(err)
    }
    instance, err := storage.NewStorage(common.HexToAddress(Address), cli)
    if err != nil {
        log.Logger.Error(err)
    }
    value, err := instance.QueryData(nil, key1)
    if err != nil {
        log.Logger.Error(err)
    }
    fmt.Println("value:", value)
}
```

### 5) Example of Capturing and Parsing StoreData Events
```
func TestCaptureStoreDataEvent(t *testing.T) {
	var storageStoreData = make(chan *storage.StorageStoreData, 100)
	wsCli, err := ethclient.Dial(NodeWsUrl)
    if err != nil {
        log.Logger.Error(err)
    }
	wsInstance, err := storage.NewStorage(common.HexToAddress(Address),wsCli)
	if err != nil {
		log.Logger.Error(err)
	}
	go func() {
	hear:
		transfer, err := wsInstance.StorageFilterer.WatchStoreData(nil, storageStoreData, nil)
		if err != nil {
			log.Logger.Error(err)
			goto hear
		}
		defer transfer.Unsubscribe()
		select {
		case errs := <-transfer.Err():
			log.Logger.Warn(err)
			goto hear
		}
	}()
	for {
		select {
		case event := <-storageStoreData:
			fmt.Println("StoreData key:", event.Key)
			fmt.Println("StoreData value:", event.Value)
		}
	}
}
```
