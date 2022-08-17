# ------------------------------------------------------------------------------
# JITSI-CUSTOMIZATION.SH
# ------------------------------------------------------------------------------
set -e
source $INSTALLER/000-source

# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
MACH="eb-jitsi-host"
cd $MACHINES/$MACH

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
[ "$DONT_RUN_JITSI_CUSTOMIZATION" = true ] && exit

echo
echo "------------------- JITSI CUSTOMIZATION -------------------"

# ------------------------------------------------------------------------------
# CUSTOMIZATION
# ------------------------------------------------------------------------------
JITSI_ROOTFS="/var/lib/lxc/eb-jitsi/rootfs"
JITSI_MEET_CONFIG="$JITSI_ROOTFS/etc/jitsi/meet/$JITSI_FQDN-config.js"
JITSI_MEET_INTERFACE="$JITSI_ROOTFS/usr/share/jitsi-meet/interface_config.js"
FOLDER="/root/jitsi-customization"

# is there an old customization folder?
if [[ -d "/root/jitsi-customization" ]]; then
    FOLDER="/root/jitsi-customization-new"
    rm -rf $FOLDER

    echo "There is already an old customization folder."
    echo "A new folder will be created as $FOLDER"
fi

cp -arp root/jitsi-customization-202208 $FOLDER

sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" $FOLDER/README.md
sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" $FOLDER/README.md
sed -i "s/___TURN_FQDN___/$TURN_FQDN/g" $FOLDER/customize.sh
sed -i "s/___JITSI_FQDN___/$JITSI_FQDN/g" $FOLDER/customize.sh

sed -i "/^\s*\/\/ disableModeratorIndicator:/a \
\    disableModeratorIndicator: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableReactions:/a \
\    disableReactions: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableReactionsModeration:/a \
\    disableReactionsModeration: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disablePolls:/a \
\    disablePolls: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableAudioLevels:/a \
\    disableAudioLevels: true," \
    $JITSI_MEET_CONFIG
sed -i "/\s*enableNoAudioDetection:/ s/true/false/" $JITSI_MEET_CONFIG
sed -i "/\s*enableNoisyMicDetection:/ s/true/false/" $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ resolution:/a \
\    resolution: 360," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ constraints:/i \
\    constraints: {\\
\      video: {\\
\        height: {\\
\          ideal: 360,\\
\          max: 360,\\
\          min: 360,\\
\        },\\
\      },\\
\    }," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ recordingService:/i \
\    hiddenDomain: 'recorder.$JITSI_FQDN',\\
\\\
\    recordingService: {\\
\      enabled: true,\\
\      sharingEnabled: false,\\
\      hideStorageWarning: true,\\
\    }," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ localRecording:/i \
\    localRecording: {\\
\      disable: true,\\
\    }," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ liveStreaming:/i \
\    liveStreaming: {\\
\      enabled: true,\\
\    }," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ hideLobbyButton:/a \
\    hideLobbyButton: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ requireDisplayName:/a \
\    requireDisplayName: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*enableWelcomePage:/ s/true/false/" $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ enableClosePage:/a \
\    enableClosePage: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ defaultLanguage:/a \
\    defaultLanguage: 'en'," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableProfile:/a \
\    disableProfile: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ enableFeaturesBasedOnToken:/a \
\    enableFeaturesBasedOnToken: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ enableInsecureRoomNameWarning:/a \
\    enableInsecureRoomNameWarning: false," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ toolbarButtons:/i \
\    toolbarButtons: [\\
\      'camera',\\
\      'chat',\\
\      'desktop',\\
\      'hangup',\\
\      'microphone',\\
\      'profile',\\
\      'settings',\\
\      'tileview',\\
\      'toggle-camera',\\
\    ]," \
    $JITSI_MEET_CONFIG
# p2p.enabled
sed -i "/^\s*enabled:/ s/true/false/" $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disabledSounds:/a \
\    disabledSounds: [\\
\      'ASKED_TO_UNMUTE_SOUND',\\
\      'E2EE_OFF_SOUND',\\
\      'E2EE_ON_SOUND',\\
\      'KNOCKING_PARTICIPANT_SOUND',\\
\      'LIVE_STREAMING_OFF_SOUND',\\
\      'LIVE_STREAMING_ON_SOUND',\\
\      'NO_AUDIO_SIGNAL_SOUND',\\
\      'NOISY_AUDIO_INPUT_SOUND',\\
\      'OUTGOING_CALL_EXPIRED_SOUND',\\
\      'OUTGOING_CALL_REJECTED_SOUND',\\
\      'OUTGOING_CALL_RINGING_SOUND',\\
\      'OUTGOING_CALL_START_SOUND',\\
\      'REACTION_SOUND',\\
\      'RECORDING_OFF_SOUND',\\
\      'RECORDING_ON_SOUND',\\
\      'TALK_WHILE_MUTED_SOUND',\\
\    ]," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableInviteFunctions:/a \
\    disableInviteFunctions: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ doNotStoreRoom:/a \
\    doNotStoreRoom: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableRemoteMute:/a \
\    disableRemoteMute: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ breakoutRooms:/i \
\    breakoutRooms: {\\
\      hideAddRoomButton: true,\\
\      hideAutoAssignButton: true,\\
\      hideJoinRoomButton: true,\\
\    }," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableAddingBackgroundImages:/a \
\    disableAddingBackgroundImages: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ hideConferenceSubject:/a \
\    hideConferenceSubject: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ hideParticipantsStats:/a \
\    hideParticipantsStats: true," \
    $JITSI_MEET_CONFIG
sed -i "/^\s*\/\/ disableChatSmileys:/a \
\    disableChatSmileys: true," \
    $JITSI_MEET_CONFIG

cp $JITSI_MEET_CONFIG $FOLDER/files/
cp $JITSI_MEET_INTERFACE $FOLDER/files/
