#!/bin/bash

#TKG patch order:

#549 clock monotonic
#567 bypass compositor
#718 vulkan childwindow
#1044 fsync staging
#1066 fsync spincount
#1078 fs hack
#1125 rawinput
#1207 LAA
#1221 winex11-MWM
#1229 steam client swap
#1236 protonify rpc
#1237 protonify
#1239 steam bits
#1332 SDL
#1333 SDL2
#1339 gamepad additions
#1375 vr
#1386 vk bits
#1387 fs hack integer scaling
#1391 winevulkan
#1396 msvcrt native builtin
#1411 win10
#1417 dxvk_config

    cd gst-plugins-ugly
    git reset --hard HEAD
    git clean -xdf
    echo "add Guy's patch to fix wmv playback in gst-plugins-ugly"
    patch -Np1 < ../patches/gstreamer/asfdemux-always_re-initialize_metadata_and_global_metadata.patch
    patch -Np1 < ../patches/gstreamer/asfdemux-Re-initialize_demux-adapter_in_gst_asf_demux_reset.patch
    patch -Np1 < ../patches/gstreamer/asfdemux-Only_forward_SEEK_event_when_in_push_mode.patch
    patch -Np1 < ../patches/gstreamer/asfdemux-gst_asf_demux_reset_GST_FORMAT_TIME_fix.patch
    cd ..

    # warframe controller fix
    git checkout lsteamclient
    cd lsteamclient
    patch -Np1 < ../patches/proton-hotfixes/proton-lsteamclient_disable_SteamController007_if_no_controller.patch
    patch -Np1 < ../patches/proton-hotfixes/proton-lsteamclient-killer-instinct-match-end-fix.patch
    cd ..

    # VKD3D patches
    cd vkd3d
    git reset --hard HEAD
    git clean -xdf
    cd ..

    # Valve DXVK patches
    cd dxvk
    git reset --hard HEAD
    git clean -xdf
    patch -Np1 < ../patches/dxvk/proton-dxvk_avoid_spamming_log_with_requests_for_IWineD3D11Texture2D.patch
    patch -Np1 < ../patches/dxvk/proton-dxvk_add_new_dxvk_config_library.patch
    patch -Np1 < ../patches/dxvk/dxvk-async.patch
    cd ..

    #WINE STAGING
    cd wine-staging
    git reset --hard HEAD
    git clean -xdf
    cd ..

    #WINE
    cd wine
    git reset --hard HEAD
    git clean -xdf

    echo "proton gamepad conflict fix"
    git revert --no-commit da7d60bf97fb8726828e57f852e8963aacde21e9
    
    echo "video color fix endless space 2"
    git revert --no-commit fd25ba65e0eb9fedfb2cdfa2b7a4b16e0401dfdf
    
    #https://bugs.winehq.org/show_bug.cgi?id=49990
    echo "this breaks some game launchers"
    git revert --no-commit bd27af974a21085cd0dc78b37b715bbcc3cfab69

# disable these when using proton's gamepad patches
#    -W dinput-SetActionMap-genre \
#    -W dinput-axis-recalc \
#    -W dinput-joy-mappings \
#    -W dinput-reconnect-joystick \
#    -W dinput-remap-joystick \
    
    echo "applying staging patches"
    ../wine-staging/patches/patchinstall.sh DESTDIR="." --all \
    -W dinput-SetActionMap-genre \
    -W dinput-axis-recalc \
    -W dinput-joy-mappings \
    -W dinput-reconnect-joystick \
    -W dinput-remap-joystick
            
    #WINE FAUDIO
    #echo "applying faudio patches"
    #patch -Np1 < ../patches/faudio/faudio-ffmpeg.patch
    
    ### GAME PATCH SECTION ###
    
    #fix this
    echo "mech warrior online"
    patch -Np1 < ../patches/game-patches/mwo.patch

    echo "final fantasy XIV old launcher render fix"
    patch -Np1 < ../patches/game-patches/ffxiv-launcher.patch

    echo "assetto corsa"
    patch -Np1 < ../patches/game-patches/assettocorsa-hud.patch

    echo "sword art online"
    patch -Np1 < ../patches/game-patches/sword-art-online-gnutls.patch

    echo "origin downloads fix" 
    patch -Np1 < ../patches/game-patches/origin-downloads_fix.patch
        
#  TODO: Add game-specific check
    echo "mk11 patch"
    patch -Np1 < ../patches/game-patches/mk11.patch

#   The game uses CEG which does not work in proton.    
#    echo "blackops 2 fix"
#    patch -Np1 < ../patches/game-patches/blackops_2_fix.patch

    echo "bloons TD6 fix"
    patch -Np1 < ../patches/game-patches/bloons_TD6_fix.patch
    
    echo "avengers and mafia definitive edition patches"
    patch -Np1 < ../patches/game-patches/mafia_de.patch
    
    echo "killer instinct vulkan fix"
    patch -Np1 < ../patches/game-patches/killer-instinct-winevulkan_fix.patch
    
    echo "warhammer 40k: inquisitor martyr loading fix"
    patch -Np1 < ../patches/game-patches/warhammer-40k-inquisitor-martyr-loading.patch
    
    echo "Paul's Diablo 1 menu fix"
    patch -Np1 < ../patches/game-patches/diablo_1_menu.patch
    
    echo "Destiny 2 runtime timestamp fix"
    patch -Np1 < ../patches/destiny2_runtime_timestamp_fix.patch

    ### END GAME PATCH SECTION ###
    
    ### PROTON PATCH SECTION ###
    
    echo "clock monotonic"
    patch -Np1 < ../patches/proton/01-proton-use_clock_monotonic.patch
    
    echo "bypass compositor"
    patch -Np1 < ../patches/proton/02-proton-FS_bypass_compositor.patch

    #WINE FSYNC
    echo "applying fsync patches"
    patch -Np1 < ../patches/proton/03-proton-fsync_staging.patch

    echo "LAA"
    patch -Np1 < ../patches/proton/04-proton-LAA_staging.patch

    echo "proton overlay mouse lag fix"
    patch -Np1 < ../patches/proton/05-proton-overlay_input_lag_fix.patch
    
    echo "proton force mouse fullscreen grab"
    patch -Np1 < ../patches/proton/06-proton-nofshack-force-fullscreen-grab-mouse.patch
    
    echo "proton alt-tab hotfixes"
    patch -Np1 < ../patches/proton/07-proton-alt-tab-focus-hotfixes.patch

    echo "steamclient swap"
    patch -Np1 < ../patches/proton/08-proton-steamclient_swap.patch

#    disabled for now -- was breaking Catherine Classic in 5.9
#    echo "audio patch test"
#    patch -Np1 < ../patches/proton/09-proton-xaudio2_stop_engine.patch

    echo "protonify"
    patch -Np1 < ../patches/proton/10-proton-protonify_staging.patch

    echo "protonify-audio"
    patch -Np1 < ../patches/proton/11-proton-pa-staging.patch
    
    echo "steam bits"
    patch -Np1 < ../patches/proton/12-proton-steam-bits.patch

    echo "SDL Joystick"
    patch -Np1 < ../patches/proton/13-proton-sdl_joy.patch
    patch -Np1 < ../patches/proton/14-proton-sdl_joy_2.patch

    echo "proton gamepad additions"
    patch -Np1 < ../patches/proton/15-proton-gamepad-additions.patch

    echo "Valve VR patches"
    patch -Np1 < ../patches/proton/16-proton-vrclient.patch
    
    echo "proton winevulkan"
    patch -Np1 < ../patches/proton/17-proton-winevulkan-nofshack.patch

    echo "amd ags"
    patch -Np1 < ../patches/proton/18-proton-amd_ags.patch

    echo "msvcrt overrides"
    patch -Np1 < ../patches/proton/19-proton-msvcrt_nativebuiltin.patch

    echo "atiadlxx"
    patch -Np1 < ../patches/proton/20-proton-atiadlxx.patch

    echo "valve registry entries"
    patch -Np1 < ../patches/proton/21-proton-01_wolfenstein2_registry.patch
    patch -Np1 < ../patches/proton/22-proton-02_rdr2_registry.patch
    patch -Np1 < ../patches/proton/23-proton-03_nier_sekiro_ds3_registry.patch
    patch -Np1 < ../patches/proton/24-proton-04_cod_registry.patch
    
    echo "valve rdr2 fixes"
    patch -Np1 < ../patches/proton/25-proton-rdr2-fixes.patch

    #echo "valve cod fixes"
    #patch -Np1 < ../patches/proton/26-proton-cod_gdi32_PE_conversion.patch
    
    echo "set prefix win10"
    patch -Np1 < ../patches/proton/27-proton-win10_default.patch

    echo "dxvk_config"
    patch -Np1 < ../patches/proton/28-proton-dxvk_config.patch

    echo "hide wine prefix update"
    patch -Np1 < ../patches/proton/29-proton-hide_wine_prefix_update_window.patch

    echo "proton-specific manual mfplat dll register patch"
    patch -Np1 < ../patches/proton/30-proton-proton_mediafoundation_dllreg.patch
    
    ### END PROTON PATCH SECTION ###

    ### WINE PATCH SECTION ###

    echo "applying winevulkan childwindow"
    patch -Np1 < ../patches/wine-hotfixes/winevulkan-childwindow.patch

    echo "applying WoW vkd3d wine patches"
    patch -Np1 < ../patches/wine-hotfixes/vkd3d/D3D12SerializeVersionedRootSignature.patch
    patch -Np1 < ../patches/wine-hotfixes/vkd3d/D3D12CreateVersionedRootSignatureDeserializer.patch

    ### END WINEPATCH SECTION ###
    
    #WINE CUSTOM PATCHES
    #add your own custom patch lines below
        
    ./dlls/winevulkan/make_vulkan
    ./tools/make_requests
    autoreconf -f

    #end
