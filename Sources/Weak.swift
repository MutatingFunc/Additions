//
//  Weak.swift
//  StandardAdditions
//
//  Created by James Froggatt on 25.04.2016.
//  Copyright © 2016 James Froggatt. All rights reserved.
//

/*
inactive - no valid use found
*/

///a weak wrapper around a reference-type
public struct Weak<Reference: AnyObject> {
	public weak var target: Reference?
	public init(_ target: Reference?) {self.target = target}
}
