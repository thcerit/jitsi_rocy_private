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

#### /etc/jitsi/jibri/xorg-video-dummy.conf (eb-jibri-template on jibri node)

```
Section "Screen"
  SubSection "Display"
    Virtual 1280 720
    #Virtual 1920 1080
  EndSubSection
EndSection
```
