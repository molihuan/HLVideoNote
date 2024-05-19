#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"
///need copy generated_plugin_registrant.cc include
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <desktop_multi_window/desktop_multi_window_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <gal/gal_plugin_c_api.h>
#include <irondash_engine_context/irondash_engine_context_plugin_c_api.h>
#include <media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h>
#include <media_kit_video/media_kit_video_plugin_c_api.h>
#include <nb_utils/nb_utils_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <screen_brightness_windows/screen_brightness_windows_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <super_native_extensions/super_native_extensions_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <window_manager/window_manager_plugin.h>


FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  ///  https://github.com/MixinNetwork/flutter-plugins/issues/58
  /// Multi window registration plugin start
  ///不能在这里注册自己即DesktopMultiWindowPlugin
    DesktopMultiWindowSetWindowCreatedCallback([](void *controller) {
        auto *flutter_view_controller =
                reinterpret_cast<flutter::FlutterViewController *>(controller);
        auto *registry = flutter_view_controller->engine();
        ConnectivityPlusWindowsPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
        FileSelectorWindowsRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("FileSelectorWindows"));
        GalPluginCApiRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("GalPluginCApi"));
        IrondashEngineContextPluginCApiRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("IrondashEngineContextPluginCApi"));
        MediaKitLibsWindowsVideoPluginCApiRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("MediaKitLibsWindowsVideoPluginCApi"));
        MediaKitVideoPluginCApiRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("MediaKitVideoPluginCApi"));
        NbUtilsPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("NbUtilsPlugin"));
        PermissionHandlerWindowsPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
        ScreenBrightnessWindowsPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("ScreenBrightnessWindowsPlugin"));
        ScreenRetrieverPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
        SuperNativeExtensionsPluginCApiRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("SuperNativeExtensionsPluginCApi"));
        UrlLauncherWindowsRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("UrlLauncherWindows"));
        WindowManagerPluginRegisterWithRegistrar(
                registry->GetRegistrarForPlugin("WindowManagerPlugin"));
    });

  /// Multi window registration plugin end

  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
