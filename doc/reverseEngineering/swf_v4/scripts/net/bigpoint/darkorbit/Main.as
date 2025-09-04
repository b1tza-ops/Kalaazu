package net.bigpoint.darkorbit
{
   import com.bigpoint.filecollection.event.FileCollectionEvent;
   import com.bigpoint.filecollection.event.FileCollectionFileLoadEvent;
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.BPLocaleEvent;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.plugins.DynamicPropsPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.soenkerohde.logging.SOSLoggingTarget;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.Security;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.Font;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.Dictionary;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.achievement.AchievementManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.collisionDetection.CollisionDetection;
   import net.bigpoint.darkorbit.groupsystem.GroupManager;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.InstantLogViewConfig;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.net.BaseAssembly;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.PreloadPattern;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.settings.Profiler;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   import net.bigpoint.darkorbit.tdm.TDMManager;
   import net.bigpoint.darkorbit.version.Version;
   
   public class Main extends MovieClip
   {
      
      public static var gameXML:XML;
      
      public static var mapsXML:XML;
      
      public static var profileXML:XML;
      
      public static var css:StyleSheet;
      
      public static var helpLink:String;
      
      public static const version:String = Version.VALUE;
      
      public static var serverVersion:String = "Unknown";
      
      public static var answerToLife:int = 42;
      
      public static var drawClickRadius:Boolean = false;
      
      public static var showCross:Boolean = false;
      
      public static const useLaserPool:Boolean = false;
      
      public static const useCollectablePool:Boolean = false;
      
      public static const ENV_LOCAL_SERVER:int = 0;
      
      public static const ENV_DEV_SERVER:int = 1;
      
      public static const ENV_LIVE_SERVER:int = 2;
      
      public static var showBetaWindow:Boolean = false;
      
      public static const mouseEventsEnabled:Boolean = false;
      
      private static var fontEurostileFl:Class = Main_fontEurostileFl;
      
      private static var fontEurostileHeaFl:Class = Main_fontEurostileHeaFl;
      
      public static var MAX_LOADING_RETRIES:int = 4;
      
      Font.registerFont(fontEurostileFl);
      Font.registerFont(fontEurostileHeaFl);
      
      public var screenManager:ScreenManager;
      
      private var connectionManager:ConnectionManager;
      
      private var guiManager:GuiManager;
      
      private var questManager:QuestManager;
      
      private var tdmManager:TDMManager;
      
      private var _groupManager:GroupManager;
      
      public var achievementManager:AchievementManager;
      
      private var loadingItemIndex:Number = 0;
      
      private var profiler:Profiler;
      
      public var antStart:Boolean;
      
      private var preloader:MovieClip;
      
      private var progressBar:MovieClip;
      
      private var progressBarGlow:MovieClip;
      
      private var isLoadingKoreanPic:Boolean = false;
      
      private var progressBarTextField:TextField;
      
      private var environment:int;
      
      private var scheduledDisconnect:Boolean;
      
      private var _autoStartEnabled:Boolean;
      
      private var revisions:Dictionary = new Dictionary();
      
      private var appContextMenu:ContextMenu;
      
      public function Main()
      {
         super();
         BaseAssembly.setMain(this);
         CollisionDetection.registerStage(stage);
         TweenPlugin.activate([DynamicPropsPlugin]);
         this.stage.scaleMode = StageScaleMode.NO_SCALE;
         this.stage.align = StageAlign.TOP_LEFT;
         this.initLocaleProxy();
         BPLocale.setEntry("loadingClaim","LOADING…");
         var _loc1_:InstantLogViewConfig = new InstantLogViewConfig();
         _loc1_.y = 16;
         _loc1_.width = 200;
         _loc1_.maxEntries = 4;
         _loc1_.displayTime = 5;
         Settings.instantLogViewConfig = _loc1_;
         this.environment = ENV_LIVE_SERVER;
         stage.stageFocusRect = false;
         this.screenManager = new ScreenManager(this);
         this.parseFlashvars();
         this.createContextmenu();
      }
      
      public static function parseBooleanFromInt(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         return true;
      }
      
      public static function parseBooleanFromString(param1:String) : Boolean
      {
         if(param1 == "true")
         {
            return true;
         }
         return false;
      }
      
      public static function fatalError(param1:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("clientError",param1);
         }
         else
         {
            System.exit(0);
         }
      }
      
      public static function getRandomCount(param1:int, param2:int) : int
      {
         return param1 + Math.floor(Math.random() * (param2 - param1 + 1));
      }
      
      public static function removeCommaAtEnd(param1:String) : String
      {
         if(param1.length > 0)
         {
            if(param1.charAt(param1.length - 1) == ",")
            {
               return param1.substring(0,param1.length - 1);
            }
         }
         return param1;
      }
      
      private function continueInit() : void
      {
         var _loc1_:String = null;
         this.connectionManager = new ConnectionManager(this);
         if(!this.antStart)
         {
            _loc1_ = Settings.staticHost + Settings.basePath;
         }
         ResourceManager.init(_loc1_);
         AudioManager.init(this);
         this.guiManager = new GuiManager(this);
         this.achievementManager = new AchievementManager(this.guiManager);
         this.tdmManager = new TDMManager(this);
         stage.frameRate = 60;
         this.initLocale();
      }
      
      public function setScheduledDisconnect(param1:Boolean) : void
      {
         this.scheduledDisconnect = param1;
      }
      
      public function getScheduledDisconnect() : Boolean
      {
         return this.scheduledDisconnect;
      }
      
      private function initLocaleProxy() : void
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_["ttip_booty-key"] = "Booty Keys: %COUNT%";
         _loc1_["ttip_jump-vouchers_count"] = "Jump Vouchers: %COUNT%";
         _loc1_["msg_loot_harvest_init"] = "You started looting.";
         _loc1_["msg_loot_error_generic"] = "Looting cancelled.";
         _loc1_["msg_loot_error_hostile_attack"] = "Looting cancelled because you were attacked.";
         _loc1_["msg_loot_error_hero_attack"] = "Looting cancelled because you attacked someone.";
         _loc1_["msg_loot_error_hero_moved"] = "Looting cancelled because you moved.";
         _loc1_["log_msg_gather_skill-design_s"] = "You received a %TYPE%-Skill-Design.";
         _loc1_["log_msg_gather_design_s"] = "You received a %TYPE%-Design.";
         _loc1_["log_msg_gather_speed-generator_p"] = "You received %COUNT% %TYPE% speed generators.";
         BPLocale.initProxy(_loc1_);
      }
      
      private function initLocale() : void
      {
         BPLocale.language = Settings.language;
         BPLocale.host = Settings.dynamicHost;
         BPLocale.path = "flashinput/translationSpacemap.php?lang=%LANG%";
         BPLocale.addEventListener(BPLocaleEvent.LANGUAGELOADED,this.handleBPLocaleLanguageLoaded);
         BPLocale.addEventListener(BPLocaleEvent.LANGUAGE_LOADING_ERROR,this.handleBPLocaleLanguageLoadingError);
         BPLocale.load(this.environment);
      }
      
      private function handleBPLocaleLanguageLoadingError(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleLanguageLoaded(param1:BPLocaleEvent) : void
      {
         BPLocale.setEntry("btn_label_bannerad_shipdesignGlory","Get it now for only %PRICE|SYMBOL%!");
         BPLocale.setEntry("title_hunter_of_the_day",BPLocale.getText("title_19"));
         BPLocale.setEntry("title_bounty_hunter",BPLocale.getText("title_20"));
         BPLocale.setEntry("log_msg_gather_extra-energy_s",BPLocale.getText("log_msg_gather_extra-energy_s_collected"));
         BPLocale.setEntry("log_msg_gather_extra-energy_p",BPLocale.getText("log_msg_gather_extra-energy_p_collected"));
         this.createContextmenu();
         this.loadGameXML();
      }
      
      private function loadGameXML() : void
      {
         var _loc1_:URLRequest = null;
         if(this.antStart)
         {
            _loc1_ = new URLRequest("xml/game.xml");
         }
         else
         {
            _loc1_ = new URLRequest(Settings.basePath + "xml/game.xml?__cv=" + this.revisions["gameXML"]);
         }
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.handleGameXMLLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
         _loc2_.load(_loc1_);
      }
      
      private function loadProfileXML() : void
      {
         var _loc1_:URLRequest = null;
         if(this.antStart)
         {
            _loc1_ = new URLRequest("xml/profile.xml");
         }
         else
         {
            _loc1_ = new URLRequest(Settings.basePath + "xml/profile.xml?__cv=" + this.revisions["profileXML"]);
         }
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.handleProfileXMLLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
         _loc2_.load(_loc1_);
      }
      
      private function loadResourceXML() : void
      {
         ResourceManager.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_LOADED,this.handleResourceXMLLoaded);
         ResourceManager.fileCollection.addEventListener(FileCollectionEvent.RESOURCE_FILE_NOT_FOUND,this.handleResourceFileError);
         if(this.antStart)
         {
            ResourceManager.fileCollection.loadResourceFile("xml/resources.xml");
         }
         else
         {
            ResourceManager.fileCollection.loadResourceFile(Settings.basePath + "xml/resources.xml?__cv=" + this.revisions["resourcesXML"]);
         }
      }
      
      private function handleGameXMLLoaded(param1:Event) : void
      {
         var _loc3_:URLRequest = null;
         gameXML = new XML((param1.currentTarget as URLLoader).data);
         PatternManager.parsePatterns(gameXML);
         var _loc2_:ResolutionPattern = PatternManager.resolutionPatterns[Settings.resolutionID];
         this.screenManager.setScreenWidth(_loc2_.width);
         this.screenManager.setScreenHeight(_loc2_.height);
         TooltipControl.getInstance().setBounds(new Rectangle(0,0,_loc2_.width,_loc2_.height));
         this.screenManager.showSimpleMessage(BPLocale.getText("loadingClaim"),"quickloader");
         var _loc4_:String = "maps_dev.xml";
         if(this.environment != ENV_LOCAL_SERVER)
         {
            _loc4_ = "maps.php";
         }
         if(this.environment == ENV_LOCAL_SERVER)
         {
            _loc3_ = new URLRequest("xml/" + _loc4_);
         }
         else
         {
            _loc3_ = new URLRequest(Settings.dynamicHost + Settings.basePath + "xml/" + _loc4_);
         }
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(Event.COMPLETE,this.handleMapsXMLLoaded);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.handleXMLLoadingError);
         _loc5_.load(_loc3_);
      }
      
      private function handleMapsXMLLoaded(param1:Event) : void
      {
         mapsXML = new XML((param1.currentTarget as URLLoader).data);
         this.loadProfileXML();
      }
      
      private function handleResourceXMLLoaded(param1:FileCollectionEvent) : void
      {
         ResourceManager.fileCollection.load("splashscreen_0",this.handlePreloaderLoaded);
      }
      
      private function handleProfileXMLLoaded(param1:Event) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         profileXML = new XML((param1.currentTarget as URLLoader).data);
         if(profileXML.qualityLowLimit != "")
         {
            Profiler.QUALITY_LOW_LIMIT = int(profileXML.qualityLowLimit);
         }
         if(profileXML.intervalLength != "")
         {
            Profiler.INTERVAL_LENGTH = int(profileXML.intervalLength);
         }
         if(XMLList(profileXML.notificationSteps).length() > 0)
         {
            Profiler.NOTIFICATION_STEPS = [];
            for each(_loc2_ in profileXML.notificationSteps.notificationStep)
            {
               if(_loc2_.@value > 0)
               {
                  Profiler.NOTIFICATION_STEPS.push(int(_loc2_.@value));
               }
            }
         }
         this.loadResourceXML();
      }
      
      private function handlePreloaderLoaded(param1:SWFFinisher) : void
      {
         var _loc5_:TextField = null;
         var _loc2_:String = param1.fileVO.id;
         param1 = SWFFinisher(ResourceManager.fileCollection.getFinisher(_loc2_));
         this.preloader = param1.getEmbededMovieClip("splashscreen");
         var _loc3_:Array = ["splashscreen_text_movement","tf_movement","splashscreen_text_attack","tf_attack","splashscreen_text_collect","tf_collect"];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = this.preloader[_loc3_[_loc4_ + 1]];
            _loc5_.defaultTextFormat = Styles.h2Fmt;
            _loc5_.embedFonts = Styles.h2Embed;
            _loc5_.multiline = true;
            _loc5_.wordWrap = true;
            _loc5_.textColor = 16777215;
            _loc5_.antiAliasType = AntiAliasType.ADVANCED;
            _loc5_.text = BPLocale.getText(_loc3_[_loc4_]);
            _loc4_ += 2;
         }
         ResourceManager.fileCollection.load("progress_bar",this.handleProgressBarLoaded);
      }
      
      private function handleProgressBarLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:PreloadPattern = null;
         var _loc3_:int = 0;
         this.progressBar = param1.getEmbededMovieClip("progress_bar");
         this.progressBarGlow = param1.getEmbededMovieClip("glow");
         this.progressBarGlow.gotoAndStop(1);
         this.progressBar.gotoAndStop(1);
         if(!this.isLoadingKoreanPic)
         {
            this.showPreloaderInsteadOfQuickLoader();
         }
         for each(_loc2_ in PatternManager.preloaderPatterns)
         {
            ResourceManager.fileCollection.load(_loc2_.getResKey(),this.handleMapIndependentFileLoaded,this.handleFileLoadError);
         }
         _loc3_ = 30;
         this.progressBarTextField = new TextField();
         this.progressBarTextField.defaultTextFormat = Styles.systemSplashFmt;
         this.progressBarTextField.embedFonts = Styles.systemSplashEmbed;
         this.progressBarTextField.width = this.progressBar.width;
         this.progressBarTextField.multiline = false;
         this.progressBarTextField.wordWrap = false;
         this.progressBarTextField.y = _loc3_;
         this.progressBarTextField.height = this.progressBar.height - _loc3_;
         this.progressBarTextField.textColor = 16751874;
         this.progressBarTextField.antiAliasType = "advanced";
         this.progressBarTextField.selectable = false;
         this.progressBarTextField.mouseEnabled = false;
         this.progressBar.addChild(this.progressBarTextField);
         this.progressBarTextField.text = BPLocale.getText("start_but");
         this.progressBarTextField.filters = [new GlowFilter(0,0.75,4,4,6,1)];
         this.preloader.addChild(this.progressBar);
         _loc3_ = 0;
         if(Settings.resolutionID == 5)
         {
            this.preloader["_background"].x = -292;
            this.preloader["_background"].y = -155;
            this.preloader["_logo"].x = 517;
            this.preloader["_logo"].y = -3.6;
            this.preloader["tf_movement"].x = 308;
            this.preloader["tf_movement"].y = 46;
            this.preloader["tf_attack"].x = 367;
            this.preloader["tf_attack"].y = 235;
            this.preloader["tf_collect"].x = 212;
            this.preloader["tf_collect"].y = 418;
            _loc3_ = 48;
         }
         else if(Settings.resolutionID == 3)
         {
            this.preloader["_background"].x = 0;
            this.preloader["_background"].y = -143;
            this.preloader["_logo"].x = 976;
            this.preloader["_logo"].y = 6;
            this.preloader["tf_movement"].x = 604;
            this.preloader["tf_movement"].y = 58;
            this.preloader["tf_attack"].x = 663;
            this.preloader["tf_attack"].y = 247;
            this.preloader["tf_collect"].x = 503;
            this.preloader["tf_collect"].y = 430;
            _loc3_ = 35;
         }
         else if(Settings.resolutionID == 2)
         {
            this.preloader["_background"].x = -112;
            this.preloader["_background"].y = -85;
            this.preloader["_logo"].x = 747;
            this.preloader["_logo"].y = 66;
            this.preloader["tf_movement"].x = 493;
            this.preloader["tf_movement"].y = 116;
            this.preloader["tf_attack"].x = 551;
            this.preloader["tf_attack"].y = 305;
            this.preloader["tf_collect"].x = 391;
            this.preloader["tf_collect"].y = 488;
            _loc3_ = 18;
         }
         else if(Settings.resolutionID == 1)
         {
            _loc3_ = 31;
            this.preloader["_background"].x = -112;
            this.preloader["_background"].y = -158;
            this.preloader["_logo"].x = 747;
            this.preloader["_logo"].y = -3.6;
            this.preloader["tf_movement"].x = 492;
            this.preloader["tf_movement"].y = 43;
            this.preloader["tf_attack"].x = 551;
            this.preloader["tf_attack"].y = 232;
            this.preloader["tf_collect"].x = 391;
            this.preloader["tf_collect"].y = 415;
            this.progressBar.scaleX = 0.7;
            this.progressBar.scaleY = 0.7;
         }
         else if(Settings.resolutionID == 0)
         {
            _loc3_ = 18;
            this.preloader["_background"].x = -242;
            this.preloader["_background"].y = -158;
            this.preloader["_logo"].x = 577;
            this.preloader["_logo"].y = -3.6;
            this.preloader["tf_movement"].x = 360;
            this.preloader["tf_movement"].y = 42;
            this.preloader["tf_attack"].x = 419;
            this.preloader["tf_attack"].y = 231;
            this.preloader["tf_collect"].x = 262;
            this.preloader["tf_collect"].y = 414;
            this.progressBar.scaleX = 0.7;
            this.progressBar.scaleY = 0.7;
         }
         var _loc4_:ResolutionPattern = PatternManager.resolutionPatterns[Settings.resolutionID];
         this.progressBar.x = _loc4_.width / 2 - this.progressBar.width / 2;
         this.progressBar.y = _loc4_.height;
         TweenLite.to(this.progressBar,0.5,{"y":_loc4_.height - this.progressBar.height + _loc3_});
      }
      
      private function showPreloaderInsteadOfQuickLoader() : void
      {
         if(this.preloader)
         {
            addChild(this.preloader);
            removeChild(getChildByName("quickloader"));
         }
      }
      
      private function handleMapIndependentFileLoaded(param1:FileCollectionFinisher) : void
      {
         if(++this.loadingItemIndex == PatternManager.preloaderPatterns.length)
         {
            if(this._autoStartEnabled)
            {
               this.initApplication();
            }
            else
            {
               this.progressBarTextField.text = BPLocale.getText("star_beginn");
               this.progressBar.addChild(this.progressBarGlow);
               this.progressBarGlow.gotoAndPlay(1);
               this.progressBar.buttonMode = true;
               this.progressBar.addEventListener(MouseEvent.CLICK,this.handleStartButtonClick);
            }
         }
         var _loc2_:int = this.loadingItemIndex / PatternManager.preloaderPatterns.length * 100;
         this.progressBar.gotoAndStop(_loc2_);
      }
      
      private function handleStartButtonClick(param1:MouseEvent) : void
      {
         this.initApplication();
      }
      
      private function initApplication() : void
      {
         ObjectPoolManager.precache();
         ObjectPoolManager.init();
         this.screenManager.init(this);
         this.progressBar.removeEventListener(MouseEvent.CLICK,this.handleStartButtonClick);
         this.removeChild(this.preloader);
         this.guiManager.saveReferenceUiResources(SWFFinisher(ResourceManager.fileCollection.getFinisher("ui")));
         this.guiManager.showConnectionWindow();
         this.connectionManager.connectToMap(Settings.mapID);
         this.checkSimpleShipVisualization();
         this.getGuiManager().prepareSpecialOffers();
         this.profiler = new Profiler(this);
      }
      
      private function checkSimpleShipVisualization() : void
      {
         var _loc1_:ShipPattern = null;
         for each(_loc1_ in PatternManager.shipPatterns)
         {
         }
      }
      
      private function handleResourceFileError(param1:FileCollectionEvent) : void
      {
      }
      
      private function handleFileLoadError(param1:FileCollectionFileLoadEvent) : void
      {
      }
      
      private function handleXMLLoadingError(param1:IOErrorEvent) : void
      {
      }
      
      private function createLogger() : void
      {
         var _loc1_:SOSLoggingTarget = new SOSLoggingTarget();
         _loc1_.server = "localhost";
         _loc1_.includeLevel = true;
         _loc1_.includeCategory = true;
         Log.addTarget(_loc1_);
      }
      
      private function parseFlashvars() : void
      {
         var key:String = null;
         var val:String = null;
         var flashvars:Object = null;
         var resolutionID:int = 0;
         var supportedResolutionIds:Array = null;
         var configRaw:Array = null;
         var logConfig:InstantLogViewConfig = null;
         var i:int = 0;
         try
         {
            flashvars = LoaderInfo(this.root.loaderInfo).parameters;
            for(key in flashvars)
            {
               val = String(flashvars[key]);
               switch(key)
               {
                  case "dynamicHost":
                     Settings.dynamicHost = "http://" + val + "/";
                     break;
                  case "userID":
                     Hero.userID = int(val);
                     break;
                  case "factionID":
                     Hero.factionID = int(val);
                     break;
                  case "sessionID":
                     Hero.sessionID = val;
                     break;
                  case "mapID":
                     Settings.mapID = int(val);
                     break;
                  case "basePath":
                     Settings.basePath = val;
                     if(Settings.basePath.charAt(Settings.basePath.length) != "/")
                     {
                        Settings.basePath += "/";
                     }
                     break;
                  case "cdn":
                     Settings.staticHost = val;
                     break;
                  case "lang":
                     Settings.language = val;
                     break;
                  case "pid":
                     Settings.projectID = int(val);
                     break;
                  case "antstart":
                     this.antStart = true;
                     this.environment = int(val);
                     break;
                  case "resolutionID":
                     resolutionID = int(val);
                     Settings.resolutionID = resolutionID;
                     Settings.lastResolutionID = resolutionID;
                     Settings.initialResolutionID = resolutionID;
                     break;
                  case "boardLink":
                     Settings.boardLink = val;
                     break;
                  case "helpLink":
                     helpLink = val;
                     break;
                  case "loadingClaim":
                     BPLocale.setEntry("loadingClaim",decodeURIComponent(flashvars[key]));
                     break;
                  case "localGS":
                     if(!(val.length == 0 || val == "0"))
                     {
                        if(val != "1")
                        {
                           Settings.defaultGameServer = val;
                        }
                        else
                        {
                           Settings.defaultGameServer = "localhost";
                        }
                     }
                     break;
                  case "chatHost":
                     Settings.chatHost = val;
                     Security.allowDomain(Settings.chatHost);
                     break;
                  case "supportedResolutions":
                     supportedResolutionIds = val.split(",");
                     PatternManager.supportedResolutionIds = [];
                     i = 0;
                     while(i < supportedResolutionIds.length)
                     {
                        PatternManager.supportedResolutionIds[parseInt(supportedResolutionIds[i])] = true;
                        i++;
                     }
                     break;
                  case "autoStartEnabled":
                     this._autoStartEnabled = Boolean(int(val));
                     break;
                  case "instantLogEnabled":
                     Settings.showInstantLog = Boolean(int(val));
                     break;
                  case "hpNumbersOnMapEnabled":
                     Settings.SHOW_HP_NUMBERS_ON_MAP = Boolean(int(val));
                     break;
                  case "jsEventTrackingEnabled":
                     Settings.JS_EVENT_TRACKING_ENABLED = Boolean(int(val));
                     break;
                  case "doubleClickAttackEnabled":
                     Settings.doubleclickAttackEnabled = Boolean(int(val));
                     break;
                  case "resourcesXmlHash":
                     this.revisions["resourcesXML"] = val;
                     break;
                  case "gameXmlHash":
                     this.revisions["gameXML"] = val;
                     break;
                  case "profileXmlHash":
                     this.revisions["profileXML"] = val;
                     break;
                  case "maxLoadingRetries":
                     Main.MAX_LOADING_RETRIES = int(val);
                     break;
                  case "logConfig":
                     configRaw = val.split(",");
                     logConfig = new InstantLogViewConfig();
                     logConfig.y = int(configRaw[0]);
                     logConfig.width = int(configRaw[1]);
                     logConfig.maxEntries = int(configRaw[2]);
                     logConfig.displayTime = int(configRaw[3]);
                     Settings.instantLogViewConfig = logConfig;
                     break;
                  case "allowChat":
                     Settings.createChat = Boolean(int(val));
                     break;
               }
            }
            if(Settings.staticHost != null && Settings.staticHost.length > 0)
            {
               Security.allowDomain(Settings.staticHost);
            }
            else
            {
               Settings.staticHost = Settings.dynamicHost;
            }
            Security.allowDomain(Settings.dynamicHost);
            if(Hero.sessionID == null)
            {
               this.loadLocalConfig();
            }
            else
            {
               this.continueInit();
            }
         }
         catch(error:Error)
         {
         }
      }
      
      private function loadLocalConfig() : void
      {
         var _loc1_:URLRequest = new URLRequest("debugConfig.xml");
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.handleConfigXmlLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.handleConfigXmlLoadingError);
         _loc2_.load(_loc1_);
      }
      
      private function handleConfigXmlLoadingError(param1:IOErrorEvent) : void
      {
         fatalError("debugConfig.xml not found. Stop Application.");
      }
      
      private function handleConfigXmlLoaded(param1:Event) : void
      {
         var _loc2_:XML = XML(param1.currentTarget.data);
         var _loc3_:int = int(_loc2_.resolutionID);
         Settings.resolutionID = _loc3_;
         Settings.lastResolutionID = _loc3_;
         Settings.initialResolutionID = _loc3_;
         Hero.userID = int(_loc2_.userId);
         Settings.mapID = int(_loc2_.mapId);
         Hero.sessionID = _loc2_.sessionId;
         Settings.language = _loc2_.language;
         Settings.projectID = int(_loc2_.projectId);
         if(String(_loc2_.localGs) != "0")
         {
            if(String(_loc2_.localGs) != "1")
            {
               Settings.defaultGameServer = String(_loc2_.localGs);
            }
            else
            {
               Settings.defaultGameServer = "localhost";
            }
         }
         this.antStart = true;
         this.environment = int(_loc2_.serverEnv);
         Settings.dynamicHost = "http://" + _loc2_.dynamicHost + "/";
         Settings.basePath = _loc2_.basePath;
         if(Settings.basePath.charAt(Settings.basePath.length) != "/")
         {
            Settings.basePath += "/";
         }
         Settings.chatHost = _loc2_.chatHost;
         Security.allowDomain(Settings.chatHost);
         this._autoStartEnabled = Boolean(int(_loc2_.autostartEnabled));
         Settings.showInstantLog = Boolean(parseInt(_loc2_.instantlogEnabled));
         Settings.SHOW_HP_NUMBERS_ON_MAP = Boolean(parseInt(_loc2_.hpNumbersOnMapEnabled));
         var _loc4_:InstantLogViewConfig = new InstantLogViewConfig();
         _loc4_.y = parseInt(_loc2_.logConfigY);
         _loc4_.width = parseInt(_loc2_.logConfigWidth);
         _loc4_.maxEntries = parseInt(_loc2_.logConfigMaxEntries);
         _loc4_.displayTime = parseInt(_loc2_.logConfigDisplayTime);
         Settings.instantLogViewConfig = _loc4_;
         this.continueInit();
      }
      
      public function createMap(param1:int) : void
      {
         if(this.screenManager.map != null)
         {
            this.screenManager.map.cleanup();
         }
         else
         {
            this.screenManager.zoomOut(true);
         }
         this.screenManager.map = new Map(this,param1);
         this.screenManager.map.init();
         if(Settings.lastMapID != param1)
         {
            this.screenManager.showBigMessage(BPLocale.getText("map_map") + " " + this.screenManager.map.getName(),2,2);
         }
      }
      
      private function createContextmenu() : void
      {
         this.appContextMenu = new ContextMenu();
         this.removeDefaultMenuItems();
         this.addCustomMenuItems();
         this.contextMenu = this.appContextMenu;
      }
      
      private function removeDefaultMenuItems() : void
      {
         this.appContextMenu.hideBuiltInItems();
      }
      
      private function addCustomMenuItems() : void
      {
         var _loc1_:ContextMenuItem = new ContextMenuItem(BPLocale.getText("label_version").replace(/%VERSION%/,version));
         this.appContextMenu.builtInItems.quality = true;
         this.appContextMenu.customItems.push(_loc1_);
      }
      
      public function getConnectionManager() : ConnectionManager
      {
         return this.connectionManager;
      }
      
      public function getGuiManager() : GuiManager
      {
         return this.guiManager;
      }
      
      public function getProfiler() : Profiler
      {
         return this.profiler;
      }
      
      public function getQuestManager() : QuestManager
      {
         if(this.questManager == null)
         {
            this.questManager = new QuestManager(this);
         }
         return this.questManager;
      }
      
      public function getEnvironment() : int
      {
         return this.environment;
      }
      
      public function getTDMManager() : TDMManager
      {
         return this.tdmManager;
      }
      
      public function getGroupManager() : GroupManager
      {
         if(this._groupManager == null)
         {
            this._groupManager = new GroupManager(this);
         }
         return this._groupManager;
      }
   }
}

