// This file contains 'Jest' test cases for the Company class

const Company = require('../src/Company');
const Department = require('../src/Department');


/*
Test case 1:
Create a Company object with the name 'TechCorp' and verify that the company has been created successfully

Test case 2:
Create a Company object with the name 'TechCorp' and add a department to the company. Verify that the department has been added successfully

Test case 3:
Create a Company object with the name 'TechCorp' and add multiple departments to the company. Verify that the departments have been added successfully

Test case 4:
Create a Company object with the name 'TechCorp' and add a department to the company. Try adding the same department again and verify that an error is thrown

Test case 5:
Create a Company object with the name 'TechCorp' and try adding an invalid department (null, undefined, or an object that is not an instance of the Department class). Verify that an error is thrown
*/


// Test case 1
describe('Company class', () => {
    it('should create a company with the name "TechCorp"', () => {
        const company = new Company('TechCorp');
        expect(company.name).toBe('TechCorp');
    });
});

// Test case 2
describe('Company class', () => {
    it('should add a department to the company', () => {
        const company = new Company('TechCorp');
        const department = new Department('1', 'IT');
        company.addDepartment(department);
        expect(company.departments.length).toBe(1);
    });
});