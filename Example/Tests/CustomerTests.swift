import Quick
import Nimble
import nitrapi


class CustomerTests: QuickSpec {
    override func spec() {
        let accessToken = "<access token>"
        let nitrapi = Nitrapi(accessToken: accessToken)
        
        describe("customer") {

            do {
                let customer = try nitrapi.getCustomer()
                it("is gotten as expected") {
                    
                    expect(customer!.username) == "bitowl"
                    print(nitrapi.getRateLimitRemaining())
                    print(customer!.username)
                    print(customer?.avatar ?? "no avatar")
                }
            } catch {
                print("Error: no customer found")
            }
        }
        
        describe("services") {
            it("get service") {
                let service = try? nitrapi.getService(1194254)
                expect(service!!.id) == 1194254
                
                let gameserver : Gameserver = (try? service!!.getGameserver())!!
                expect(gameserver.game) == "mcrbuk"
                try? gameserver.doRestart()
            }
        }
    }
}
