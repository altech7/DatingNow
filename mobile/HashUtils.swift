//
//  HashUtils.swift
//  DatingNow
//
//  Created by Antoine ALTMAYER on 21/02/2017.
//  Copyright © 2017 Altmayer Antoine. All rights reserved.
//

import UIKit
import CommonCrypto
import IDZSwiftCommonCrypto

class HashUtils {

    static func encryptToMD5(signature:String) -> String {
        let md5s2 : Digest = Digest(algorithm:.md5)
        md5s2.update(string: signature)
        
        return hexString(fromArray: md5s2.final())
    }
}
