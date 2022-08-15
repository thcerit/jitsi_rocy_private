## Manual Customizations

#### /etc/prosody/conf.avail/JITSI_FQDN.cfg.lua (eb-jitsi)

- check `authentication = "token"`, `app_id` and `app_secret`
- check `allow_empty_token = false`
- check `enable_domain_verification = false`
- check `token_affiliation` in `conference` component
- check `token_owner_party` in `conference` component
- check `jibri_autostart` in `conference` component

Restart the service if there are any changes:

```bash
systemctl restart prosody.service
```

#### /etc/jitsi/videobridge/sip-communicator.properties (eb-jitsi)

- Disable `org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS` as `172.22.22.14`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS`

Restart the service if there are any changes:

```bash
systemctl restart jitsi-videobridge2.service
```

#### /root/jitsi-customization/files/JITSI_FQDN-config.js (jms-host)

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
- `localRecording.disable: true`
- `liveStreaming.enabled: false`
- `hiddenDomain: 'recorder.JITSI_FQDN'` (this line should be added)
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
  - `hangup`
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

#### /root/jitsi-customization/files/interface_config.js (jms-host)

- `APP_NAME`
- `DEFAULT_BACKGROUND: '#040404'`
- `DISABLE_DOMINANT_SPEAKER_INDICATOR: true`
- `GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false`
- `HIDE_INVITE_MORE_HEADER: true`
- `JITSI_WATERMARK_LINK`
- `MOBILE_APP_PROMO: false`

#### customize.sh (jms-host)

```bash
cd /root/jitsi-customization
bash customize.sh
```

#### /var/lib/lxc/eb-jitsi/rootfs/usr/share/jitsi-meet/index.html (jms-host)

Add the following line into `<head>`. Use the current date instead of `RELEASE`.

```html
<link rel="stylesheet" href="css/custom.css?v=RELEASE">
```

To get the current date:

```bash
date +'%Y%m%d%H%M%S'
```

#### get JMS key (jibri-host)

Run this command if `jms.pub` doesn't exist in `/root/.ssh/authorized_keys`.

```bash
curl -k https://<JMS_IP_ADDRESS>/static/jms.pub >> /root/.ssh/authorized_keys
```

#### add Jibri (jms-host)

```bash
add-jibri-node <JIBRI_NODE_IP> <STREAM_SERVER_IP>
```

#### /var/lib/lxc/eb-jibri-template/rootfs/etc/hosts (jibri-host)

Add the followings if the Jibri nodes are in the same local network with JMS:

```
JMS_LOCAL_IP    JITSI_FQDN
JMS_LOCAL_IP    TURNS_FQDN
```

#### /var/lib/lxc/eb-jibri-template/rootfs/etc/jitsi/jibri/xorg-video-dummy.conf (jibri-host)

Update `Virtual`

```
Section "Screen"
  SubSection "Display"
    Virtual 1280 720
    #Virtual 1920 1080
  EndSubSection
EndSection
```

#### restart Jibri (jibri-host)

```bash
systemctl stop jibri-ephemeral-container.service
systemctl start jibri-ephemeral-container.service
```
