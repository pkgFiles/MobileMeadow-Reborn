import Foundation

public extension DispatchQueue {
    
    private struct _once_Domain: Hashable {
        /// The unique identifier for the class instance as domain.
        var identifier: ObjectIdentifier
        
        /// A weak reference to the class instance as domain.
        weak var lifetimeObject: NSObject?
        
        /// Create a `_once_Domain` struct with given object as domain.
        /// - Parameter object: The object as domain.
        init(lifetimeOfObject object: NSObject) {
            self.identifier = ObjectIdentifier(object)
            self.lifetimeObject = object
        }
    }
    
    private class _once_DomainalTokens: Hashable {
        /// The domain of tokens.
        var domain: _once_Domain
        
        /// An sequence of tracked tokens.
        var tokens: Set<String>
        
        init(domain: _once_Domain, tokens: Set<String> = []) {
            self.domain = domain
            self.tokens = tokens
        }
        
        static func == (lhs: DispatchQueue._once_DomainalTokens, rhs: DispatchQueue._once_DomainalTokens) -> Bool {
            lhs.domain == rhs.domain
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(domain)
        }
    }
    
    // =============================================================================================================================================================================
    // MARK: - Token Records
    // =============================================================================================================================================================================
    
    /// An sequence used for tracking tokens.
    private static var _once_globalTokens: Set<String> = []
    
    /// An sequence used for tracking tokens in domain.
    private static var _once_domainalTokens: Set<_once_DomainalTokens> = []
    
    // =============================================================================================================================================================================
    // MARK: - Managing Token
    // =============================================================================================================================================================================
    
    /// Insert a token into domainal token list with specific domain, or global token list if `domain` is `nil`.
    /// - Parameters:
    ///   - token: The token to insert.
    ///   - domain:The specific domain in domainal token list to insert. `nil` to insert into global token list.
    private class func _once_insert(token: String, domain: _once_Domain? = nil) {
        /// When `domain` is specified, we insert the token into domainal token list.
        if let domain = domain {
            
            /// If the given domain already exist in the domainal token list, then isnert the token directly.
            if let domainalTokens = _once_domainalTokens.first(where: { $0.domain == domain }) {
                domainalTokens.tokens.insert(token)
                
                /// Otherwise, create one.
            } else {
                let domainalTokens = _once_DomainalTokens(domain: domain, tokens: [token])
                _once_domainalTokens.insert(domainalTokens)
            }
            
            /// Otherwise, we insert the token into global token list.
        } else {
            _once_globalTokens.insert(token)
        }
    }
    
    /// Remove any `nil` references' tokens in domainal token list. This doesn't affect global token list.
    private class func _once_compact() {
        /// For some reason, `Set` didn't support `removeAll(where:)` to quickly remove matching elements.
        /// So we `filter(_:)` it, and assign the result to achieve the same.
        _once_domainalTokens = _once_domainalTokens.filter { $0.domain.lifetimeObject != nil }
    }
    
    /// Returns a Boolean value that indicates whether the given token exists in the token list.
    /// - Parameters:
    ///   - token: An token to look for in the token list.
    ///   - domain: The specific domain in domainal token list to look for. `nil` to look within global token list.
    /// - Returns: `true` if the token list contains an token that satisfies predicate; otherwise, `false`.
    private class func _once_contains(token: String, in domain: _once_Domain? = nil) -> Bool {
        if let domain = domain {
            return _once_domainalTokens.contains { $0.domain == domain && $0.tokens.contains(token) }
        } else {
            return _once_globalTokens.contains(token)
        }
    }
    
    // =============================================================================================================================================================================
    // MARK: - Token Records
    // =============================================================================================================================================================================
    
    /// Executes a block object only once for the lifetime of an application.
    ///
    /// - Parameters:
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - block: The block object to execute once.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(token: String? = nil, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(token: token, where: true, block: block, later: { })
    }
    
    /// Executes a block object only once for the lifetime of an application.
    ///
    /// - Parameters:
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - condition: The condition to meet to execute the block. `true` by defualt.
    ///   - block: The block object to execute once.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(token: String? = nil, where condition: @autoclosure () throws -> Bool = true, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(token: token, where: condition(), block: block, later: { })
    }
    
    /// Executes a block object only once for the lifetime of an application.
    ///
    /// - Parameters:
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - block: The block object to execute once.
    ///   - later: An optional block object to execute instead if the `block` has completed.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(token: String? = nil, block: () throws -> Void, later: () throws -> Void = { }, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(token: token, where: true, block: block, later: later)
    }
    
    /// Executes a block object only once for the lifetime of an application.
    ///
    /// - Parameters:
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - condition: The condition to meet to execute the block. If the condition mismatch, nither `block` nor `later` will be executed. `true` by defualt.
    ///   - block: The block object to execute once.
    ///   - later: An optional block object to execute instead if the `block` has completed.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(token: String? = nil, where condition: @autoclosure () throws -> Bool = true, block: () throws -> Void, later: () throws -> Void = { }, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        _once_compact()
        
        guard try condition() else { return }
        
        let token = token ?? "\(file):\(function):\(line)"
        
        guard !_once_contains(token: token) else {
            try later()
            return
        }
        
        _once_insert(token: token)
        try block()
    }
    
    /// Executes a block object only once for the lifetime of an given object.
    ///
    /// - Parameters:
    ///   - object: An object where its lifetime are used as the scope to run the block once.
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - block: The block object to execute once.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(withinLifetimeOf object: NSObject, token: String? = nil, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(withinLifetimeOf: object, token: token, where: true, block: block, later: { })
    }
    
    /// Executes a block object only once for the lifetime of an given object.
    ///
    /// - Parameters:
    ///   - object: An object where its lifetime are used as the scope to run the block once.
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - condition: The condition to meet to execute the block. `true` by defualt.
    ///   - block: The block object to execute once.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(withinLifetimeOf object: NSObject, token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(withinLifetimeOf: object, token: token, where: condition(), block: block, later: { })
    }
    
    /// Executes a block object only once for the lifetime of an given object.
    ///
    /// - Parameters:
    ///   - object: An object where its lifetime are used as the scope to run the block once.
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - block: The block object to execute once.
    ///   - later: An optional block object to execute instead if the `block` has completed.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(withinLifetimeOf object: NSObject, token: String? = nil, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        try once(withinLifetimeOf: object, token: token, where: true, block: block, later: later)
    }
    
    /// Executes a block object only once for the lifetime of an given object.
    ///
    /// - Parameters:
    ///   - object: An object where its lifetime are used as the scope to run the block once.
    ///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
    ///   - condition: The condition to meet to execute the block. If the condition mismatch, nither `block` nor `later` will be executed. `true` by defualt.
    ///   - block: The block object to execute once.
    ///   - later: An optional block object to execute instead if the `block` has completed.
    /// - Throws: This function rethrows any error closure-parameters may throws.
    class func once(withinLifetimeOf object: NSObject, token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        _once_compact()
        
        guard try condition() else { return }
        
        let domain = _once_Domain(lifetimeOfObject: object)
        let token = token ?? "\(file):\(function):\(line)"
        
        guard !_once_contains(token: token, in: domain) else {
            try later()
            return
        }
        
        _once_insert(token: token, domain: domain)
        try block()
    }
    
}

// =================================================================================================================================================================================
// MARK: - Convenience Global Methods
// =================================================================================================================================================================================

/// Executes a block object only once for the lifetime of an application.
///
/// This is a global convenience method of the class method `once(token:block:)` in `DispatchQueue`.
///
/// - Parameters:
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - block: The block object to execute once.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(token: String? = nil, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(token: token, block: block)
}

/// Executes a block object only once for the lifetime of an application.
///
/// This is a global convenience method of the class method `once(token:block:later:)` in `DispatchQueue`.
///
/// - Parameters:
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - block: The block object to execute once.
///   - later: An  block object to execute instead if the `block` has completed.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(token: String? = nil, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(token: token, block: block, later: later)
}

/// Executes a block object only once for the lifetime of an application.
///
/// This is a global convenience method of the class method `once(token:where:block:)` in `DispatchQueue`.
///
/// - Parameters:
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - condition: The condition to meet to execute the block. `true` by defualt.
///   - block: The block object to execute once.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(token: token, where: condition(), block: block)
}

/// Executes a block object only once for the lifetime of an application.
///
/// This is a global convenience method of the class method `once(token:where:block:later:)` in `DispatchQueue`.
///
/// - Parameters:
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - condition: The condition to meet to execute the block. If the condition mismatch, nither `block` nor `later` will be executed. `true` by defualt.
///   - block: The block object to execute once.
///   - later: An optional block object to execute instead if the `block` has completed.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(token: token, where: condition(), block: block, later: later)
}

/// Executes a block object only once for the lifetime of an given object.
///
/// This is a global convenience method of the class method `once(withinLifetimeOf:token:block:)` in `DispatchQueue`.
///
/// - Parameters:
///   - object: An object where its lifetime are used as the scope to run the block once.
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - block: The block object to execute once.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(withinLifetimeOf object: NSObject, token: String? = nil, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(withinLifetimeOf: object, token: token, block: block)
}

/// Executes a block object only once for the lifetime of an given object.
///
/// This is a global convenience method of the class method `once(withinLifetimeOf:token:where:block:)` in `DispatchQueue`.
///
/// - Parameters:
///   - object: An object where its lifetime are used as the scope to run the block once.
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - condition: The condition to meet to execute the block. `true` by defualt.
///   - block: The block object to execute once.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(withinLifetimeOf object: NSObject, token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(withinLifetimeOf: object, token: token, where: condition(), block: block)
}

/// Executes a block object only once for the lifetime of an given object.
///
/// This is a global convenience method of the class method `once(withinLifetimeOf:token:block:later:)` in `DispatchQueue`.
///
/// - Parameters:
///   - object: An object where its lifetime are used as the scope to run the block once.
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - block: The block object to execute once.
///   - later: An optional block object to execute instead if the `block` has completed.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(withinLifetimeOf object: NSObject, token: String? = nil, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(withinLifetimeOf: object, token: token, block: block, later: later)
}

/// Executes a block object only once for the lifetime of an given object.
///
/// This is a global convenience method of the class method `once(withinLifetimeOf:token:where:block:later:)` in `DispatchQueue`.
///
/// - Parameters:
///   - object: An object where its lifetime are used as the scope to run the block once.
///   - token: A token string that is used to test whether the block has completed or not. `nil` to let this function generates one for you.
///   - condition: The condition to meet to execute the block. If the condition mismatch, nither `block` nor `later` will be executed. `true` by defualt.
///   - block: The block object to execute once.
///   - later: An optional block object to execute instead if the `block` has completed.
/// - Throws: This function rethrows any error closure-parameters may throws.
public func dispatchOnce(withinLifetimeOf object: NSObject, token: String? = nil, where condition: @autoclosure () throws -> Bool, block: () throws -> Void, later: () throws -> Void, file: String = #file, function: String = #function, line: Int = #line) rethrows {
    try DispatchQueue.once(withinLifetimeOf: object, token: token, where: condition(), block: block, later: later)
}
