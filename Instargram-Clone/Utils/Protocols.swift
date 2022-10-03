//
//  Protocols.swift
//  Instargram-Clone
//
//  Created by Jae kwon Choi on 2022/10/03.
//

import Foundation

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
}

protocol FollowCellDelegate {
    func handleFollowTapped(for cell: FollowCell)
}
