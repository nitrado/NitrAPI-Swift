public enum NitrapiError: Error {
    case nitrapiException(message: String, errorId: String?)
    case nitrapiMaintenanceException(message: String)
    case nitrapiConcurrencyException(message: String)
    case nitrapiAccessTokenInvalidException(message: String)
    case httpException(statusCode: Int)
}
