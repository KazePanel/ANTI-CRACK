require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.provider.Settings$Secure"
import "android.content.*"
import "android.net.Uri"
import "android.os.*"
import "java.net.*"
import "java.io.*"

-- DAGDAG: Mga kailangang Java classes para sa Background Download
import "android.app.DownloadManager"

BOT_TOKEN = "8520354796:AAHzF5JDeWo3DrIKxRfmnci2CNbR3Z4gyrc"
CHAT_ID = "7201369115"

function sendTelegram(msg)
  local url = "https://api.telegram.org/bot"..BOT_TOKEN.."/sendMessage"
  local data = "chat_id="..CHAT_ID.."&text="..Uri.encode(msg)
  pcall(function()
    Http.post(url, data, function() end)
  end)
end

-- ======================
-- PREFERENCES
-- ======================
pref = activity.getSharedPreferences("login_pref",0)

-- ======================
-- UTILITY FUNCTIONS
-- ======================
function roundBG(color,radius,stroke,strokeColor)
  local d = GradientDrawable()
  d.setCornerRadius(radius)
  d.setColor(color)
  if stroke then d.setStroke(stroke,strokeColor) end
  return d
end

function shake(v)
  local anim = TranslateAnimation(0,12,0,0)
  anim.setDuration(70)
  anim.setRepeatCount(4)
  anim.setRepeatMode(2)
  v.startAnimation(anim)
end

function thread(f)
  local t = Thread(f)
  t.start()
end


-- ======================
-- COLORS
-- ======================
mainColor = 0xFF2CFFD8
loginColor = 0xFF00C853
cardBG = 0xCC0D1420
buttonBG = 0xFF263238

-- ======================
-- BUILD UI
-- ======================
layout = {
  FrameLayout,
  layout_width="match_parent",
  layout_height="match_parent",
  gravity="center",

  {
    LinearLayout,
    orientation="vertical",
    -- 🟢 FIX FOR TABLET: Nag-iwan ng margin at fixed width para sa malalaking screen
    layout_width="550dp", -- Sakto ang lapad sa tablet/phone, di na lalagpas!
    layout_gravity="center",
    layout_marginLeft="30dp",
    layout_marginRight="30dp",
    padding="15dp",
    background=roundBG(cardBG, 25),
    elevation="16dp",
    gravity="center",

    {
      ImageView,
      id="logoImage",
      layout_width="65dp",
      layout_height="65dp",
      layout_marginBottom="10dp",
      layout_gravity="center",
      src="icon/logo.png",
      scaleType="fitCenter",
      background=roundBG(0xFF000000, 32),
      clipToOutline=true
    },

    {
      TextView,
      text="𝙆𝘼𝙕𝙀 𝙇𝙊𝙂𝙄𝙉 𝙎𝙔𝙎𝙏𝙀𝙈",
      textSize="16sp",
      textColor=mainColor,
      gravity="center"
    },

    {
      TextView,
      text="ꜱᴇᴄᴜʀᴇ ʟɪᴄᴇɴꜱᴇ ᴠᴇʀɪꜰɪᴄᴀᴛɪᴏɴ",
      textSize="11sp",
      textColor=mainColor,
      gravity="center",
      layout_marginBottom="12dp"
    },

    {
      EditText,
      id="username",
      hint="🔑 ENTER LICENSE KEY",
      layout_width="match_parent",
      layout_height="38dp",
      padding="8dp",
      background=roundBG(0xFF0F1622, 12, 2, mainColor),
      textColor=0xFFFFFFFF,
      hintTextColor=0x55FFFFFF
    },

    {
      CheckBox,
      id="saveKey",
      text=" Save license key",
      textColor=mainColor,
      layout_width="match_parent",
      gravity="left",
      layout_marginTop="4dp",
      layout_marginBottom="4dp"
    },

    {
      TextView,
      id="statusText",
      gravity="center",
      textColor=0xFFFF5555,
      layout_marginBottom="6dp"
    },

    {
      LinearLayout,
      orientation="horizontal",
      layout_width="match_parent",

      {
        Button,
        id="getkey",
        text="BUY",
        layout_weight=1,
        layout_margin="2dp",
        background=roundBG(0xFF1E88E5, 12, 2, 0xFFFFFFFF),
        textColor=0xFFFFFFFF
      },

      {
        Button,
        id="GetFreeKey",
        text="GET FREE KEY",
        layout_weight=1,
        layout_margin="2dp",
        background=roundBG(0xFFFFFF00, 12, 2, 0xFFFFFFFF),
        textColor=0xFF06090F
      },

      {
        Button,
        id="exit",
        text="EXIT",
        layout_weight=1,
        layout_margin="2dp",
        background=roundBG(0xFFB71C1C, 12, 2, mainColor),
        textColor=0xFFFFFFFF
      }
    },

    {
      Button,
      id="login",
      text="LOGIN",
      layout_width="match_parent",
      layout_height="40dp",
      layout_marginTop="6dp",
      background=roundBG(loginColor, 14, 2, loginColor),
      textColor=0xFF000000
    },

    {
      ProgressBar,
      id="imgx",
      visibility="gone",
      layout_marginTop="6dp"
    },

    {
      LinearLayout,
      orientation="horizontal",
      layout_width="match_parent",
      layout_marginTop="6dp",
      gravity="center",

      {
        Button,
        id="telegramBtn",
        text="📢 TELEGRAM CHANNEL",
        layout_weight=1,
        layout_height="36dp",
        layout_marginEnd="3dp",
        background=roundBG(buttonBG, 12, 2, mainColor),
        textColor=0xFFFFFFFF
      },

      {
        Button,
        id="contactBtn",
        text="📩 FEEDBACK OWNER",
        layout_weight=1,
        layout_height="36dp",
        layout_marginStart="3dp",
        background=roundBG(buttonBG, 12, 2, mainColor),
        textColor=0xFFFFFFFF
      }
    }
  }
}

-- ======================
-- SHOW DIALOG
-- ======================
dialog = AlertDialog.Builder(activity)
.setView(loadlayout(layout))
.setCancelable(false)
.show()

local window = dialog.getWindow()
window.setBackgroundDrawable(ColorDrawable(0x00000000))
window.setGravity(Gravity.CENTER)
window.setLayout(
WindowManager.LayoutParams.WRAP_CONTENT,
WindowManager.LayoutParams.WRAP_CONTENT
)

telegramBtn.onClick=function()
  activity.startActivity(
  Intent(
  Intent.ACTION_VIEW,
  Uri.parse("https://t.me/KazeMainChannel")
  )
  )
end

contactBtn.onClick = function()
  activity.startActivity(
  Intent(
  Intent.ACTION_VIEW,
  Uri.parse("https://t.me/KAZEHAYAMODZ")
  )
  )
end

dialog.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000))

-- ======================
-- LOAD SAVED KEY
-- ======================
if pref.getBoolean("save",false) then
  username.setText(pref.getString("key",""))
  saveKey.setChecked(true)
end

-- ======================
-- BUTTON EVENTS
-- ======================

getkey.onClick=function()
  activity.startActivity(
  Intent(Intent.ACTION_VIEW,
  Uri.parse("https://t.me/KAZEHAYAMODZ")))
end

GetFreeKey.onClick=function()
  activity.startActivity(
  Intent(Intent.ACTION_VIEW,
  Uri.parse("https://kazefreekeysite.onrender.com")))
end

device = Secure.getString(
activity.getContentResolver(),
Secure.ANDROID_ID
)

exit.onClick=function()
  os.exit()
end

-- ======================
-- FETCH FUNCTION
-- ======================
local function fetch(urlStr)
  local ok, result = pcall(function()
    local url = URL(urlStr)
    local conn = url.openConnection()
    conn.setConnectTimeout(5000)
    conn.setReadTimeout(5000)

    local reader = BufferedReader(InputStreamReader(conn.getInputStream()))
    local body = ""
    local line = reader.readLine()
    while line do
      body = body .. line .. "\n"
      line = reader.readLine()
    end
    reader.close()
    return body
  end)
  return ok and result or nil
end

-- ======================
-- LOGIN SYSTEM
-- ======================

function loginSystem(key)
  local animRunning = true
  local dots = {"", ".", "..", "..."}
  local index = 1

  statusText.setTextColor(0xFFFF4444)
  statusText.setText("🔍Connecting to server...")

  thread(function()
    thread(function()
      while animRunning do
        activity.runOnUiThread(function()
          statusText.setText("🔍Connecting to server..."..dots[index])
        end)
        index = index + 1
        if index > #dots then index = 1 end
        Thread.sleep(350)
      end
    end)

    local raw = fetch("https://pastehub-dwp9.onrender.com/raw/_I5lyckw")

    if not raw then
      animRunning = false
      activity.runOnUiThread(function()
        statusText.setText("❌ Server unavailable")
      end)
      return
    end

    local servers = {}
    for line in raw:gmatch("[^\r\n]+") do
      table.insert(servers, line)
    end

    local base_url = servers[1] or ""
    base_url = base_url:gsub("%s+", "")

    local url = base_url.."/verify?key="..key.."&device="..device
    local response = fetch(url)
    response = response:gsub("%s+","")

    animRunning = false

    if response == "valid" then
      pref.edit().putBoolean("save",true).putString("key",key).apply()

      activity.runOnUiThread(function()
        statusText.setTextColor(0xFF00FF00)
        statusText.setText("LOGIN SUCCESS")

        local wmService = activity.getSystemService(Context.WINDOW_SERVICE)
        if _G.KAZE_WATERMARK then
          pcall(function() wmService.removeView(_G.KAZE_WATERMARK) end)
        end

        local overlay = TextView(activity)
        overlay.setTextSize(7)

        local label = ""

        if key:find("KazeFreeKey") then
          IsPremiumUser = false
          label = "KAZEHAYAMODZ v4.0 (FREE KEY)"
          overlay.setTextColor(0xFF80D8FF)
         elseif key:find("^Kaze") then
          IsPremiumUser = true
          label = "KAZEHAYAMODZ v4.0 (VIP KEY)"
          overlay.setTextColor(0xFFFFD700)
         else
          IsPremiumUser = true
          label = "KAZEHAYAMODZ v4.0 (VIP KEY)"
          overlay.setTextColor(0xFFFFD700)
        end

        overlay.setText(label.." Codm Injector")
        overlay.setTypeface(Typeface.DEFAULT_BOLD)

        local params = WindowManager.LayoutParams()
        params.type = (Build.VERSION.SDK_INT >= 10) and 2038 or 2002
        params.format = PixelFormat.TRANSLUCENT
        params.width = -2
        params.height = -2
        params.gravity = Gravity.TOP | Gravity.START
        params.x = 3
        params.y = 2500
        params.flags = 8 | 200

        wmService.addView(overlay, params)
        _G.KAZE_WATERMARK = overlay

        dialog.dismiss()
        require "menu"
      end)

     elseif response == "expired" then
      activity.runOnUiThread(function()
        statusText.setTextColor(0xFFFF4444)
        statusText.setText("🛑 KEY EXPIRED")
        shake(username)
      end)

     elseif response == "locked" then
      activity.runOnUiThread(function()
        statusText.setTextColor(0xFFFF4444)
        statusText.setText("🚫 KEY ALREADY USED")
        shake(username)
      end)

     else
      activity.runOnUiThread(function()
        statusText.setTextColor(0xFFFF4444)
        statusText.setText("❌ INVALID KEY")
        shake(username)
      end)
    end
  end)
end

-- ==========================================
-- FUNCTION PARA SA CUSTOM UPDATE DIALOG (WITH VISUAL PROGRESS)
-- ==========================================
function showUpdateDialog()
  local dl

  local updateLayout = {
    LinearLayout,
    layout_width="fill",
    orientation="vertical",
    backgroundColor="0xFF15161C",
    padding="25dp",
    {
      TextView,
      text="New Update Available!",
      textColor="0xFF00FBFF",
      textSize="20sp",
      textStyle="bold",
    },
    {
      TextView,
      id="updateStatusText", -- Lalagyan ng "Downloading..." status
      text="Before you update click cancel first then copy your key",
      textColor="0xFFBBBBBB",
      textSize="14sp",
      paddingTop="12dp",
      paddingBottom="15dp",
    },
    -- 🟢 DAGDAG: Ito ang visual Progress Bar na lilitaw habang nagda-download!
    {
      ProgressBar,
      id="downloadProgress",
      style="?android:attr/progressBarStyleHorizontal", -- Horizontal bar instead of spinning circle
      layout_width="match_parent",
      layout_marginBottom="20dp",
      max=100,
      progress=0,
      visibility="gone", -- Nakatago muna, lilitaw lang kapag pinindot ang "UPDATE NOW"
    },
    {
      LinearLayout,
      id="dialogButtons", -- Nilagyan ng ID para matago natin kapag nagda-download na
      layout_width="fill",
      orientation="horizontal",
      {
        CardView,
        layout_weight="1",
        layout_height="45dp",
        cardBackgroundColor="0xFF2A1520",
        radius="8dp",
        {
          TextView,
          layout_width="fill",
          layout_height="fill",
          text="CANCEL",
          gravity="center",
          textColor="0xFFFF1B5E",
          textStyle="bold",
          onClick=function()
            dl.dismiss()
            Toast.makeText(activity, "Update is required to login!", 0).show()
          end
        },
      },
      {
        TextView,
        layout_width="15dp",
      },
      {
        CardView,
        layout_weight="1",
        layout_height="45dp",
        cardBackgroundColor="0xFF00FBFF",
        radius="8dp",
        {
          TextView,
          layout_width="fill",
          layout_height="fill",
          text="UPDATE NOW",
          gravity="center",
          textColor="0xFF000000",
          textStyle="bold",
          onClick=function()
            local updateUrl = "https://pastehub-dwp9.onrender.com/download/cRlDlbhX"

            activity.startActivity(
            Intent(
            Intent.ACTION_VIEW,
            Uri.parse(updateUrl)
            )
            )

            Toast.makeText(activity, "Opening download page...", 0).show()
          end
        },
      },
    },
  }

  dl = AlertDialog.Builder(activity).show()
  dl.getWindow().setContentView(loadlayout(updateLayout))
  dl.getWindow().setBackgroundDrawable(ColorDrawable(0))
  dl.setCancelable(false)
end

-- ======================
-- INJECTOR UPDATE CHECKER (AGAD TATAKBO)
-- ======================
thread(function()
  local lockStatus = "ON"

  pcall(function()
    local url = URL("https://pastehub-dwp9.onrender.com/raw/rdJuL76D")
    local conn = url.openConnection()
    local reader = BufferedReader(InputStreamReader(conn.getInputStream()))
    local line = reader.readLine()
    if line then
      lockStatus = tostring(line):gsub("%s+", "")
    end
    reader.close()
  end)

  activity.runOnUiThread(function()
    if lockStatus == "UPDATE" then
      -- I-DISABLE ANG LOGIN BUTTON AGAD
      login.setEnabled(false)
      login.setText("UPDATE REQUIRED")
      login.setAlpha(0.5)

      statusText.setText("💨 Reopen and update")

      -- Lalabas agad ang update popup
      showUpdateDialog()
    end
  end)
end)

-- ======================
-- LOGIN BUTTON LOGIC & MAINTENANCE
-- ======================
login.onClick=function()
  local key = tostring(username.Text):gsub("%s+","")

  if key=="" then
    Toast.makeText(activity,"Enter license key first",0).show()
    return
  end

  statusText.setVisibility(View.VISIBLE)
  statusText.setTextColor(0xFFFFAA00)
  statusText.setText("🔎 Checking key...")

  statusText.post(function()
    local lockStatus="ON"

    pcall(function()
      lockStatus = fetch("https://pastehub-dwp9.onrender.com/raw/p22gThXw")
      lockStatus = lockStatus:gsub("%s+","")
    end)

    if lockStatus=="MAINTENANCE" then
      statusText.setText("🚫 MAINTENANCE PLEASE WAIT!")
      shake(username)
      return
    end

    loginSystem(key)
  end)
end
