
open class CloudServerProduct: PartPricing {
    public override init(nitrapi: Nitrapi, locationId: Int) {
        super.init(nitrapi: nitrapi, locationId: locationId)
        product = "cloud_server"
        additionals["image_id"] = "0"
    }
    
    open func setImage(_ image: Int) {
        additionals["image_id"] = "\(image)"
    }
}
