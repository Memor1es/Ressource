Config = {
	DiscordToken = "NzIyODUwNDczNDIxNDM5MDg2.XupKEw.ID9_I9SOpuuLfld3A88K1ym1b-I",
	GuildId = "427626975302123520",

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["TestRole"] = "Some Role ID" -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
	}
}
