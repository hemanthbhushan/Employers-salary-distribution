// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract EmployersSalary is Ownable{

    uint256 midLevelSalary = 1 ether ;
    uint256 highLevelSalary = 2 ether ;

    struct EmployeeDetails{
        string name;
        string position;
        uint8 idNo;
        address accountNo;
        bool salaryPaid;
    }

   EmployeeDetails[] public highLevelEmployeeDetails;
   EmployeeDetails[] public midLevelEmployeeDetails;

modifier checkLevelOfEmployee(uint256 _levelOfEmployee ){
     require(_levelOfEmployee == 1 || _levelOfEmployee == 2,"only two type of employess 1 = highLevel , 2 = midLevel ");
     _;
}


//use this function to register
   function registerEmployee(string memory _name,uint8 _idNo,address payable  _accountNo,uint256 _levelOfEmployee) public onlyOwner  checkLevelOfEmployee(_levelOfEmployee ) returns(string memory) {
     return  registerEmployessToPosition(_name,_idNo,_accountNo,_levelOfEmployee);
   }
//use this function to remove
   function removeEmployees(address _accountNo,uint256 _levelOfEmployee) external  onlyOwner checkLevelOfEmployee(_levelOfEmployee ) returns (bool){
     return removeEmployess(_accountNo,_levelOfEmployee);
       
   }

   function checkEmployeeGotPaid(address _accountNo,uint _levelOfEmployee ) public view  returns(bool){
       require(_accountNo != address(0),"please do not enter the zero address");
       if(_levelOfEmployee == 1){
       uint256 length = highLevelEmployeeDetails.length;
       uint count;
       for(uint256 i = 0;i< length;i++){
           if(highLevelEmployeeDetails[i].accountNo == _accountNo ){
               return highLevelEmployeeDetails[i].salaryPaid;
             }
             count++;
          }
       if(count == length){
           revert("employee not found");
    
          }
          return true;
       }else{
            uint256 length = highLevelEmployeeDetails.length;
       uint count;
       for(uint256 i = 0;i< length;i++){
           if(midLevelEmployeeDetails[i].accountNo == _accountNo ){
               return highLevelEmployeeDetails[i].salaryPaid;
             }
             count++;
          }
       if(count == length){
           revert("employee not found");
    
          }
          return true;

       }
   }
  
//use this function to send salaries

   function sendSalaries(uint256 _levelOfEmployee ) public payable  onlyOwner checkLevelOfEmployee(_levelOfEmployee ) returns(bool){
       if(_levelOfEmployee == 1){
         for(uint i = 0;i<highLevelEmployeeDetails.length;i++){
           require( !highLevelEmployeeDetails[i].salaryPaid,"salary already paid for this employee");
           highLevelEmployeeDetails[i].salaryPaid = true;
           payable(highLevelEmployeeDetails[i].accountNo).transfer(highLevelSalary );
           
       }
        return true;
     }else {
          
            for(uint i = 0;i<midLevelEmployeeDetails.length;i++){
           require( !midLevelEmployeeDetails[i].salaryPaid,"salary already paid for this employee");
             midLevelEmployeeDetails[i].salaryPaid = true;
           payable(midLevelEmployeeDetails[i].accountNo).transfer(midLevelSalary );
        
          }
           return true;
   }
   
   }

   function checkNoOfEmployees() public view  returns (uint256 total){
      uint highLevel = highLevelEmployeeDetails.length;
      uint lowLevel =   midLevelEmployeeDetails.length;
      total = highLevel+lowLevel;
     

   }




    function registerEmployessToPosition(string memory _name,uint8 _idNo,address payable  _accountNo,uint256 _levelOfEmployee) internal returns (string memory) {
        require(_accountNo != address(0),"please do not enter the zero address");
     
       if(_levelOfEmployee == 1){
             EmployeeDetails memory detailsHighLevel = EmployeeDetails(_name,"MidLevelEMployee",_idNo,_accountNo,false);
            highLevelEmployeeDetails.push(detailsHighLevel);
            uint length = highLevelEmployeeDetails.length;
            return   highLevelEmployeeDetails[length-1].name;
       }else{
          
            EmployeeDetails memory detailsMidLevel = EmployeeDetails(_name,"MidLevelEMployee",_idNo,_accountNo,false);
            midLevelEmployeeDetails.push(detailsMidLevel);
            uint length = midLevelEmployeeDetails.length;
            return   midLevelEmployeeDetails[length-1].name;

       }
   }

   function removeEmployess(address _accountNo,uint256 _levelOfEmployee) internal returns(bool) {
       require(_accountNo != address(0),"please do not enter the zero address");
      
       if(_levelOfEmployee == 1){
              uint256 length = highLevelEmployeeDetails.length;
       uint count;
       for(uint256 i = 0;i< length;i++){
           if(highLevelEmployeeDetails[i].accountNo == _accountNo ){
               highLevelEmployeeDetails[i] = midLevelEmployeeDetails[length-1];
               highLevelEmployeeDetails.pop();
           }
          count++;
       }
       if(count == length){
           revert("employee not found");
       }
       return true;


       }
       else{
            uint256 length = midLevelEmployeeDetails.length;
       uint count;
       for(uint256 i = 0;i< length;i++){
           if(midLevelEmployeeDetails[i].accountNo == _accountNo ){
               midLevelEmployeeDetails[i] = midLevelEmployeeDetails[length-1];
               midLevelEmployeeDetails.pop();
           }
          count++;
       }
       if(count == length){
           revert("employee not found");
       }
       return true;

       }

      
   }


      function setSalaries(uint _salary,uint256 _levelOfEmployees) external  onlyOwner{
        require(_levelOfEmployees == 1 || _levelOfEmployees == 2,"only two type of employess 1 = highLevel , 2 = midLevel ");
        if(_levelOfEmployees == 1){
             highLevelSalary = _salary;

        }else{
           
             midLevelSalary = _salary;
        }
       
   }


}