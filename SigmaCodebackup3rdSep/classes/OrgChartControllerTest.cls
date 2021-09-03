@isTest
public class OrgChartControllerTest {
    
    static testMethod void testGetEmployees() {
        Boolean success = true;
        try {
            Contact c = new Contact(FirstName='Lisa',LastName='Smith');
            insert c;
	        Contact[] employees = OrgChartController.getEmployees('');
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }

    static testMethod void testGetEmployeeById() {
        Boolean success = true;
        try {
            Contact c = new Contact(FirstName='Lisa',LastName='Smith');
            insert c;
	        Contact contact = OrgChartController.getEmployeeById(c.Id);
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }

    static testMethod void testGetDirectReports() {
        Boolean success = true;
        try {
            Contact c = new Contact(FirstName='Lisa',LastName='Smith');
            insert c;
	        Contact[] employees = OrgChartController.getDirectReports(c.Id);
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }

}