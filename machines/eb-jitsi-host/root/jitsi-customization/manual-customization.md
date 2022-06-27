## Manual Customizations

#### /etc/prosody/conf.avail/jitsi.mydomain.corp.cfg.lua

- `authentication`, `app_id`, `app_secret`
- `allow_empty_token = false`
- `token_affiliation`
- `token_owner_party`
- `jibri_autostart`

#### /etc/jitsi/videobridge/sip-communicator.properties

- Disable `org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS` as `172.22.22.14`
- Set `org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS`

#### /etc/jitsi/meet/DOMAIN-config.js

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
- 'fileRecordingsEnabled: true`
- `fileRecordingsServiceSharingEnabled: false`
- `liveStreamingEnabled: false`
- `hiddenDomain: 'recorder.jitsi.mydomain.corp'`
- `enableLocalRecording: false`
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

#### /usr/share/jitsi-meet/interface_config.js

- `APP_NAME`
- `DEFAULT_BACKGROUND: '#040404'`
- `DISABLE_DOMINANT_SPEAKER_INDICATOR: true`
- `GENERATE_ROOMNAMES_ON_WELCOME_PAGE: false`
- `HIDE_INVITE_MORE_HEADER: true`
- `JITSI_WATERMARK_LINK`
- `MOBILE_APP_PROMO: false`

#### /usr/share/jitsi-meet/index.html

- `<link rel="stylesheet" href="css/custom.css?v=$(date +'%Y%m%d%H%M%S')>

#### /etc/hosts (eb-jibri-template on jibri nodes)

Do the followings if the Jibri nodes are on the same local network:

- local IP for Jitsi FQDN
- local IP for TURNS FQDN

#### /etc/jitsi/jibri/xorg-video-dummy.conf (eb-jibri-template on jibri nodes)

```
Section "Screen"
  SubSection "Display"
    Virtual 1280 720
    #Virtual 1920 1080
  EndSubSection
EndSection
```
