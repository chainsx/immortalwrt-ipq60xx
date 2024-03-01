module("luci.controller.oled", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/oled") then
		return
	end
	local page = entry({"admin", "services", "oled"}, alias("admin", "services", "oled", "setting"),_("OLED"))
	page.order = 10
	page.dependent = true
	page.acl_depends = { "luci-app-oled" }
	entry({"admin", "services", "oled", "status"}, call("act_status"))
	entry({"admin", "services", "oled", "setting"}, cbi("oled/setting"),_("Setting"),30).leaf = true
end

function act_status()
	local e={}
	e.running = luci.sys.call("pgrep -f /usr/bin/oled > /dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end 
