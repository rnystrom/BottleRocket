//
//  Keyname.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import InflectorKit

func modelName(for key: String, locale: Locale = Locale.current) -> String {
    return TTTStringInflector.default().singularize(key).capitalized(with: locale)
}
