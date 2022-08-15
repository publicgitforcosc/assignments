//
//  Documented.swift
//  cosc345-2022-b
//
//  Created by andrew on 15/08/22.
//
import Foundation

/**
	Example of SwiftDoc stuff in SWIFT.
	- Parameters:
		- value: [in] The number to return.
	- Returns: The parameter passed to it.
*/
public func identity(value : Int) -> Int
	{
	return value
	}

public func two() -> Int
	{
	return identity(value: 6)
	}
