public enum UnexpectedError: Error {
    case unexpectedValue(message: String)
    case unexpectedException(exception: Error)
}
