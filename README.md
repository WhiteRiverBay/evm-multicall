## Multicall

### Deployment Address

Chain | Address
-|-
Ethereum, BSC, Base, Polygon, Arbitrum One | 0x058C6121efBF3e7C1f856928f7e9ecBC71c5772a
Tron | TS4cnF8dF7GeEgLZVrCexRK5sfZ3u235by

### Code example

#### ethers.js

multicall getEthBalance(address) view

```typescript
export const getEVMBalances = async (provider: ethers.JsonRpcProvider, addresses: string[]) => {
    const multicallAddress = '0x058C6121efBF3e7C1f856928f7e9ecBC71c5772a'
    const multicall = new ethers.Contract(multicallAddress, MULTICALL_ABI, provider)
    const multicallData = createMulticallGetEthBalanceData(addresses, multicallAddress)
    return multicall.multicallView(multicallData)
}

const createMulticallGetEthBalanceData = (addresses: string[], target: string) => {
    return addresses.map(address => {
        return {
            target: target,
            callData: encodeGetEthBalanceCall(address)
        }
    })
}
const encodeGetEthBalanceCall = (address: string) => {
    // getEthBalance(address) selector: 0x4d2301cc
    const functionSignature = '0x4d2301cc';
    const paddedAddress = address.toLowerCase().replace('0x', '').padStart(64, '0');
    return functionSignature + paddedAddress;
}
```

#### TronWeb

multicall getEthBalance(address) view

```typescript
export const getTRONBalances = async (provider: TronWeb, addresses: string[]) => {
    const multicallAddress = 'TS4cnF8dF7GeEgLZVrCexRK5sfZ3u235by'
    const tron = provider
    const constractInstance = tron.contract(MULTICALL_ABI, multicallAddress)

    // tuple must use array, according to tronweb docs https://tronweb.network/docu/docs/Interact%20with%20contract
    const calls = addresses.map(address => (
        [tron.address.toHex(multicallAddress).replace(/^41/, '0x'),
        encodeGetEthBalanceCall(
            tron.address.toHex(address).replace(/^41/, '0x')
        )
        ]
    ))

    const result = await constractInstance.multicallView(calls).call()
    return result
}

const encodeGetEthBalanceCall = (address: string) => {
    // getEthBalance(address) selector: 0x4d2301cc
    const functionSignature = '0x4d2301cc';
    const paddedAddress = address.toLowerCase().replace('0x', '').padStart(64, '0');
    return functionSignature + paddedAddress;
}
```
