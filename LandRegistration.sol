pragma solidity ^0.4.19;
contract LandRegistration{
struct LandDetails{
    //AccountID is account address
    address AccountID;
    bytes32 Ownername;
    //OwnerAddress is locaton of owner 
    bytes32 OwnerAddress;
    bytes32 GovID;
    
    bytes32 PropertyID;
    //proof of ownership
    bytes32 Pow;
    //Registered_status shows land is verifed or not
    bool Registered_status;
    //Activestatus shows land is active for this accunt id .
    // if false then it is transfered to another account
    bool Activestatus;
    address PreviousOwnerID;
}
address public government;
modifier only_gov(){
    require(government == msg.sender);
    _;
}
event VerifyLog(bytes32, address, bytes32, bytes32, bytes32, bytes32, bool, bool);
event PropertyRegisterLog(bytes32, address, bytes32, bytes32, bytes32, bytes32, bool, bool);
event TransferOwnerLog(bytes32, address, bytes32, bytes32, bytes32, bytes32, bool, bool,address);
mapping(
    bytes32 => mapping(
       address => LandDetails 
        )
    ) landdetails;

    function LandRegistration()public{
        government = msg.sender;
    }
    //Register all details of ownner and property  


    function propertyRegister(address _accountID, bytes32 _ownername, bytes32 _owneraddr, bytes32 _govID, bytes32 _propertyID, bytes32 _POW)public{
    
    landdetails[_propertyID][_accountID].PropertyID = _propertyID;
    landdetails[_propertyID][_accountID].AccountID = _accountID;
    landdetails[_propertyID][_accountID].Ownername = _ownername;
    landdetails[_propertyID][_accountID].OwnerAddress = _owneraddr;
    landdetails[_propertyID][_accountID].GovID = _govID;
    landdetails[_propertyID][_accountID].Pow = _POW;
    landdetails[_propertyID][_accountID].Registered_status = false;
    landdetails[_propertyID][_accountID].Activestatus = false;
    landdetails[_propertyID][_accountID].PreviousOwnerID = 0x0 ;

    emit PropertyRegisterLog(
            landdetails[_propertyID][_accountID].PropertyID, 
            landdetails[_propertyID][_accountID].AccountID,
            landdetails[_propertyID][_accountID].Ownername,
            landdetails[_propertyID][_accountID].OwnerAddress, 
            landdetails[_propertyID][_accountID].GovID, 
            landdetails[_propertyID][_accountID].Pow,
            landdetails[_propertyID][_accountID].Registered_status,
            landdetails[_propertyID][_accountID].Activestatus
            
            );
    
    }
    function display(bytes32 _propertyID, address _accountID)public view returns(bytes32, address,bytes32,bool,bool,address){
     return(
            landdetails[_propertyID][_accountID].PropertyID, 
            landdetails[_propertyID][_accountID].AccountID,
            landdetails[_propertyID][_accountID].Ownername,
            landdetails[_propertyID][_accountID].Registered_status,
            landdetails[_propertyID][_accountID].Activestatus,
            landdetails[_propertyID][_accountID].PreviousOwnerID
          );
        }
    
    //only government account can verify the land;
    function Verify(bytes32 _propertyID, address _accountID)public
    only_gov(){
            
            landdetails[_propertyID][_accountID].Registered_status = true;
            landdetails[_propertyID][_accountID].Activestatus = true;
            
        
        emit VerifyLog(
            landdetails[_propertyID][_accountID].PropertyID, 
            landdetails[_propertyID][_accountID].AccountID,
            landdetails[_propertyID][_accountID].Ownername,
            landdetails[_propertyID][_accountID].OwnerAddress, 
            landdetails[_propertyID][_accountID].GovID, 
            landdetails[_propertyID][_accountID].Pow,
            landdetails[_propertyID][_accountID].Registered_status,
            landdetails[_propertyID][_accountID].Activestatus
            );
    }
    function transferOwner(address trfrom_accountid, address trto_accountid, bytes32 _propertyID, bytes32 _ownername, bytes32 _owneraddr, bytes32 _govID)public {
    //transfers only by owner of the asset
    require(msg.sender == trfrom_accountid);
    //require(landdetails[_propertyID][trfrom_accountid].Registered_status);
    require(landdetails[_propertyID][trfrom_accountid].Activestatus);
    //    LandDetails memory tempLandDetails;
    // tempLandDetails = landdetails[_propertyID][trfrom_accountid];
    //Active status false makes now the land is register to another account and this current account has no effect on it 
    landdetails[_propertyID][trfrom_accountid].Activestatus = false;    
    //landdetails[_propertyID][_accountID].PropertyID = _propertyID;
    landdetails[_propertyID][trto_accountid].AccountID =trto_accountid;
    landdetails[_propertyID][trto_accountid].Ownername = _ownername;
    landdetails[_propertyID][trto_accountid].OwnerAddress = _owneraddr;
    landdetails[_propertyID][trto_accountid].GovID = _govID;
    //landdetails[_propertyID][_accountID].Pow = _POW;
    //landdetails[_propertyID][trto_accountid].Registered_status = true;
    //now the Activestatus for this account is active 
    landdetails[_propertyID][trto_accountid].Activestatus = true;
    landdetails[_propertyID][trto_accountid].Registered_status = true;
    //loading previous owner for this particular account 
    landdetails[_propertyID][trto_accountid].PreviousOwnerID = landdetails[_propertyID][trfrom_accountid].AccountID; 
    //require check whether tha land is properly transfered 
    //require(landdetails[_propertyID][trto_accountid].Activestatus);
    emit TransferOwnerLog(
            landdetails[_propertyID][trto_accountid].PropertyID, 
            landdetails[_propertyID][trto_accountid].AccountID,
            landdetails[_propertyID][trto_accountid].Ownername,
            landdetails[_propertyID][trto_accountid].OwnerAddress, 
            landdetails[_propertyID][trto_accountid].GovID, 
            landdetails[_propertyID][trto_accountid].Pow,
            landdetails[_propertyID][trto_accountid].Registered_status,
            landdetails[_propertyID][trto_accountid].Activestatus,
            landdetails[_propertyID][trto_accountid].PreviousOwnerID
            );
    }    
    
} 