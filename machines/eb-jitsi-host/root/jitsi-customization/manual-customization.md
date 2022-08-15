## Manual Customizations

#### /etc/prosody/conf.avail/JITSI_FQDN.cfg.lua (in eb-jitsi)

- `authentication`, `app_id`, `app_secret`
- `allow_empty_token = false` (after `app_secret` in main `VirtualHost`)
- `enable_domain_verification = false` (after `allow_empty_token` in main
  `VirtualHost`)
- `token_affiliation` (into `modules_enabled` in `conference` component)
- `token_owner_party` (into `modules_enabled` in `conference` component)
- `jibri_autostart` (into `modules_enabled` in `conference` component)

#### /etc/jitsi/videobridge/sip-communicator.properties (in eb-jitsi)

- Disable `org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS` as `172.22.22.14`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS`

#### /root/jitsi-customization/files/JITSI_FQDN-config.js

- `disableModeratorIndicator: true`
- `disableReactions: true`
- `disableReactionsModeration: true`
- `disablePolls: true`
- `disableAudioLevels: true`
- `enableNoAudioDetection: false`
- `enableNoisyMicDetection: false`
- `resolution: 360`
- `constraints.video.height.ideal: 360`
- `constraints.video.height.max: 360`
- `constraints.video.height.min: 360`
- `recordingService.enabled: true`
- `recordingService.sharingEnabled: false`
- `recordingService.hideStorageWarning: true`
- `liveStreamingEnabled: false`
- `hiddenDomain: 'recorder.JITSI_FQDN'`
- `localRecording.disable: true`
- `hideLobbyButton: true`
- `requireDisplayName: true`
- `enableWelcomePage: false`
- `enableClosePage: true`
- `defaultLanguage: en`
- `disableProfile: true`
- `enableFeaturesBasedOnToken: true`
- `enableInsecureRoomNameWarning: false`
- `toolbarButtons`
  - `camera`
  - `chat`
  - `desktop`
  - `microphone`
  - `profile`
  - `settings`
  - `tileview`
  - `toggle-camera`
  - `__end`
- `p2p.enabled: false`
- `disabledSounds`
  - `ASKED_TO_UNMUTE_SOUND`
  - `E2EE_OFF_SOUND`
  - `E2EE_ON_SOUND`
  - `KNOCKING_PARTICIPANT_SOUND`
  - `LIVE_STREAMING_OFF_SOUND`
  - `LIVE_STREAMING_ON_SOUND`
  - `NO_AUDIO_SIGNAL_SOUND`
  - `NOISY_AUDIO_INPUT_SOUND`
  - `OUTGOING_CALL_EXPIRED_SOUND`
  - `OUTGOING_CALL_REJECTED_SOUND`
  - `OUTGOING_CALL_RINGING_SOUND`
  - `OUTGOING_CALL_START_SOUND`
  - `REACTION_SOUND`
  - `RECORDING_OFF_SOUND`
  - `RECORDING_ON_SOUND`
  - `TALK_WHILE_MUTED_SOUND`
- `disableInviteFunctions: true`
- `doNotStoreRoom: true`
- `disableRemoteMute: true`
- `breakoutRooms.hideAddRoomButton: true`
- `breakoutRooms.hideAutoAssignButton: true`
- `breakoutRooms.hideJoinRoomButton: true`
- `disableAddingBackgroundImages: true`
- `hideConferenceSubject: true`
- `hideParticipantsStats: true`
- ? `subject`
- `notifications: []`
- `disableChatSmileys: true`

#### /root/jitsi-customization/files/interface_config.js

- `APP_NAME`
- `DEFAULT_BACKGROUND: '#040404'`
- `DISABLE_DOMINANT_SPEAKER_INDICATOR: true`
- `GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false`
- `HIDE_INVITE_MORE_HEADER: true`
- `JITSI_WATERMARK_LINK`
- `MOBILE_APP_PROMO: false`

#### customize.sh

```bash
cd /root/jitsi-customization
bash customize.sh
```

#### /usr/share/jitsi-meet/index.html

```bash
RELEASE=$(date +'%Y%m%d%H%M%S')
echo $RELEASE
```

- `<link rel="stylesheet" href="css/custom.css?v=RELEASE">

#### get JMS key

Run this command on Jibri nodes

```bash
curl -k https://<JMS_IP_ADDRESS>/static/jms.pub >> /root/.ssh/authorized_keys
```

#### add Jibri

Run this command on `JMS`

```bash
add-jibri-node <JIBRI_NODE_IP> <STREAM_SERVER_IP>
```

#### /var/lib/lxc/eb-jibri-templates/rootfs/etc/hosts (on jibri nodes)

Add the followings if the Jibri nodes are on the same local network:

```
JMS_LOCAL_IP    JITSI_FQDN
JMS_LOCAL_IP    TURNS_FQDN
```

#### /var/lib/lxc/eb-jibri-templates/rootfs/etc/jitsi/jibri/xorg-video-dummy.conf

On Jibri nodes:

```
Section "Screen"
  SubSection "Display"
    Virtual 1280 720
    #Virtual 1920 1080
  EndSubSection
EndSection
```
