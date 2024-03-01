module("luci.controller.beardropper", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/beardropper") then
		return
	end

	local page = entry({"admin", "services", "beardropper"}, alias("admin", "services", "beardropper", "setting"), _("BearDropper"))
	page.order = 20
	page.dependent = true
	page.acl_depends = { "luci-app-beardropper" }

	entry({"admin", "services", "beardropper", "setting"}, cbi("beardropper/setting"), _("Setting"), 30).leaf = true
	entry({"admin", "services", "beardropper", "log"}, form("beardropper/log"), _("Log"), 40).leaf = true
	entry({"admin", "services", "beardropper", "status"}, call("act_status"))
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep -f /usr/sbin/beardropper >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
