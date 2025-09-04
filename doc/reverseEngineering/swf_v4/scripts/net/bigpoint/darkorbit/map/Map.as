package net.bigpoint.darkorbit.map
{
   import com.bigpoint.filecollection.event.FileCollectionFileLoadEvent;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.EventManager;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.alienmothership.AlienMothershipManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.background.BackgroundManager;
   import net.bigpoint.darkorbit.collectable.CollectableManager;
   import net.bigpoint.darkorbit.combat.CombatManager;
   import net.bigpoint.darkorbit.ctb.CTBManager;
   import net.bigpoint.darkorbit.drone.DroneManager;
   import net.bigpoint.darkorbit.fireworks.FireworksManager;
   import net.bigpoint.darkorbit.lensflare.LensflareManager;
   import net.bigpoint.darkorbit.meteor.MeteorManager;
   import net.bigpoint.darkorbit.mine.MineManager;
   import net.bigpoint.darkorbit.nebula.NebulaManager;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   import net.bigpoint.darkorbit.planet.PlanetManager;
   import net.bigpoint.darkorbit.portal.PortalManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.ShipManager;
   import net.bigpoint.darkorbit.starfield.Starfield;
   import net.bigpoint.darkorbit.station.StationManager;
   
   public class Map
   {
      
      private static const MMOHome:int = 1;
      
      private static const EICHome:int = 5;
      
      private static const VRUHome:int = 9;
      
      public static const LIMITED_WIDTH:int = 5000;
      
      public static const LIMITED_HEIGHT:int = 3119;
      
      public static const STD_WIDTH:int = 21000;
      
      public static const STD_HEIGHT:int = 13100;
      
      private var mapID:int;
      
      private var name:String;
      
      private var gameserverIP:String;
      
      private var showStarfield:Boolean;
      
      private var starfieldColor:uint = 16777215;
      
      private var neighbours:Array;
      
      private var scaleFactor:Number;
      
      private var musicTypeID:int;
      
      private var main:Main;
      
      private var shipManager:ShipManager;
      
      public var alienMothershipManager:AlienMothershipManager;
      
      private var minimapManager:MinimapManager;
      
      private var mineManager:MineManager;
      
      private var backgroundManager:BackgroundManager;
      
      private var ctbManager:CTBManager;
      
      private var nebulaManager:NebulaManager;
      
      private var planetManager:PlanetManager;
      
      public var portalManager:PortalManager;
      
      private var stationManager:StationManager;
      
      public var poiManager:POIManager;
      
      public var relayStationArray:Array = [];
      
      private var collectableManager:CollectableManager;
      
      private var droneManager:DroneManager;
      
      private var lensflareManager:LensflareManager;
      
      private var meteorManager:MeteorManager;
      
      private var combatManager:CombatManager;
      
      private var eventManager:EventManager;
      
      private var fireworksManager:FireworksManager;
      
      private var finisherList:Array = [];
      
      public var valid:Boolean = true;
      
      private var pvpAllowed:Boolean = true;
      
      private var homeMapFaction:int;
      
      public var serious_width:int = 21000;
      
      public var serious_height:int = 13100;
      
      private var showNebula:Boolean;
      
      public function Map(param1:Main, param2:int)
      {
         super();
         this.main = param1;
         this.mapID = param2;
         this.shipManager = new ShipManager(this);
         this.alienMothershipManager = new AlienMothershipManager(param1.screenManager);
         this.minimapManager = new MinimapManager(this);
         this.backgroundManager = new BackgroundManager(this);
         this.nebulaManager = new NebulaManager(this);
         this.planetManager = new PlanetManager(this);
         this.portalManager = new PortalManager(this);
         this.stationManager = new StationManager(this);
         this.poiManager = new POIManager(this);
         this.collectableManager = new CollectableManager(this);
         this.droneManager = new DroneManager(this);
         this.lensflareManager = new LensflareManager(this);
         this.meteorManager = new MeteorManager(this);
         this.combatManager = new CombatManager(this);
         this.eventManager = new EventManager(this);
         this.mineManager = new MineManager(param1.screenManager.collectableLayer,this.combatManager);
         this.ctbManager = new CTBManager(param1.getGuiManager(),this.shipManager,param1.screenManager.getPortalLayer());
         this.fireworksManager = new FireworksManager(this);
         if(param2 == MMOHome)
         {
            this.setPvpAllowed(0);
            this.setHomeMapFaction(1);
         }
         else if(param2 == EICHome)
         {
            this.setPvpAllowed(0);
            this.setHomeMapFaction(2);
         }
         else if(param2 == VRUHome)
         {
            this.setPvpAllowed(0);
            this.setHomeMapFaction(3);
         }
         else
         {
            this.setPvpAllowed(1);
         }
      }
      
      public function init() : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:XML = null;
         var _loc14_:XML = null;
         var _loc15_:XML = null;
         var _loc16_:XML = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Starfield = null;
         var _loc22_:XML = null;
         var _loc23_:ResourcePattern = null;
         var _loc24_:int = 0;
         var _loc25_:String = null;
         var _loc1_:XML = Main.mapsXML;
         for each(_loc2_ in _loc1_.map)
         {
            _loc3_ = int(_loc2_.@id);
            if(_loc3_ == this.mapID)
            {
               this.main.screenManager.resetDefaults(_loc3_);
               this.name = InGameCatalog.instance.mapNames[_loc3_];
               if(this.name == null)
               {
                  if(_loc2_.@name.length() > 0)
                  {
                     this.name = _loc2_.@name;
                  }
                  else
                  {
                     this.name = "xxx";
                  }
               }
               if(_loc2_.attribute("neighbours").length() > 0)
               {
                  this.neighbours = _loc2_.neighbours.split(",");
               }
               else
               {
                  this.neighbours = null;
               }
               this.gameserverIP = _loc2_.gameserverIP;
               this.showStarfield = Main.parseBooleanFromString(_loc2_.starfield);
               if(_loc2_.starfield.@color.length() > 0)
               {
                  this.starfieldColor = uint(_loc2_.starfield.@color);
               }
               if(_loc2_.@scaleFactor.length() > 0)
               {
                  this.scaleFactor = Number(_loc2_.@scaleFactor);
               }
               else
               {
                  this.scaleFactor = 1;
               }
               this.serious_width = STD_WIDTH * this.scaleFactor;
               this.serious_height = STD_HEIGHT * this.scaleFactor;
               POIManager.noaBmdScalefactor = this.serious_width / POIManager.NOA_BMP_WIDTH;
               MinimapManager.mapFactor = this.scaleFactor;
               if(Settings.createMeteors)
               {
                  for each(_loc15_ in _loc2_.meteors.meteor)
                  {
                     this.meteorManager.prepareMeteors(int(_loc15_.@typeID),int(_loc15_.@delay),int(_loc15_.@speed),int(_loc15_.@layer));
                  }
               }
               if(this.showNebula)
               {
                  for each(_loc16_ in _loc2_.nebulas.nebula)
                  {
                     _loc4_ = 0;
                     _loc5_ = 0;
                     if(_loc16_.@layerIndex.length() > 0)
                     {
                        _loc5_ = int(_loc16_.@layerIndex);
                     }
                     this.nebulaManager.showNebula(_loc4_,_loc5_);
                  }
               }
               if(this.showStarfield && Settings.createStarfield)
               {
                  _loc17_ = this.main.screenManager.getScaledScreenWidth();
                  _loc18_ = this.main.screenManager.getScaledScreenHeight();
                  _loc19_ = ScreenManager.getHalfScreenWidth() - _loc17_ * 0.5;
                  _loc20_ = ScreenManager.getHalfScreenHeight() - _loc18_ * 0.5;
                  _loc21_ = new Starfield(_loc17_,_loc18_,this.starfieldColor);
                  _loc21_.x = _loc19_;
                  _loc21_.y = _loc20_;
                  this.main.screenManager.addStarfield(_loc21_);
               }
               if(Settings.createLensflares)
               {
                  for each(_loc22_ in _loc2_.lensflares.lensflare)
                  {
                     if(_loc22_.@typeID.length() > 0)
                     {
                        _loc4_ = int(_loc22_.@typeID);
                     }
                     this.lensflareManager.createLensFlare(int(_loc22_.@id),int(_loc22_.@x),int(_loc22_.@y),Number(_loc22_.@pFactor),Main.parseBooleanFromString(_loc22_.@star),_loc4_);
                  }
               }
               if(_loc2_.minimap.@typeID.length() > 0)
               {
                  _loc4_ = int(_loc2_.minimap.@typeID);
                  _loc23_ = PatternManager.minimapPatterns[_loc4_];
                  this.minimapManager.createMinimap(_loc23_.resKey);
               }
               for each(_loc13_ in _loc2_.backgrounds.background)
               {
                  _loc6_ = false;
                  if(_loc13_.@isMain.length() > 0)
                  {
                     _loc6_ = Main.parseBooleanFromString(_loc13_.@isMain);
                  }
                  else if(_loc2_.backgrounds.background.length() == 1)
                  {
                     _loc6_ = true;
                  }
                  _loc7_ = 10;
                  if(_loc13_.@pFactor.length() > 0)
                  {
                     _loc7_ = int(_loc13_.@pFactor);
                  }
                  _loc5_ = 0;
                  if(_loc13_.@layer.length() > 0)
                  {
                     _loc5_ = int(_loc13_.@layer);
                  }
                  _loc8_ = false;
                  if(_loc13_.@hideLensflare.length() > 0)
                  {
                     _loc8_ = Main.parseBooleanFromString(_loc13_.@hideLensflare);
                     if(_loc8_)
                     {
                        Settings.pixelPerfectCollisionWithLayers = true;
                     }
                  }
                  _loc9_ = 0;
                  if(_loc13_.@shiftX.length() > 0)
                  {
                     _loc9_ = int(_loc13_.@shiftX);
                  }
                  _loc10_ = 0;
                  if(_loc13_.@shiftY.length() > 0)
                  {
                     _loc10_ = int(_loc13_.@shiftY);
                  }
                  _loc11_ = 1;
                  if(_loc13_.@scale.length() > 0)
                  {
                     _loc11_ = Number(_loc13_.@scale);
                  }
                  _loc12_ = -1;
                  if(_loc13_.@maskID.length() > 0)
                  {
                     _loc12_ = int(_loc13_.@maskID);
                  }
                  this.backgroundManager.createBackground(int(_loc13_.@typeID),_loc6_,_loc7_,_loc5_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
               }
               _loc5_ = 0;
               for each(_loc14_ in _loc2_.planets.planet)
               {
                  _loc24_ = -1;
                  if(_loc14_.@lightsourceID.length() > 0)
                  {
                     _loc24_ = int(_loc14_.@lightsourceID);
                  }
                  _loc25_ = "";
                  if(_loc14_.@layer.length() > 0)
                  {
                     _loc5_ = int(_loc14_.@layer);
                  }
                  this.planetManager.preparePlanet(int(_loc14_.@typeID),int(_loc14_.@x),int(_loc14_.@y),int(_loc14_.@rotation),Number(_loc14_.@pFactor),_loc5_,_loc24_);
               }
               this.planetManager.startTimer();
               this.planetManager.clipLoadedEvent.addEventListener(PlanetManager.CLIP_LOADED,this.handleClipLoaded);
               this.musicTypeID = int(_loc2_.@music);
               if(Settings.createMusic)
               {
                  if(Settings.playMusic)
                  {
                     this.loadMusic();
                  }
               }
            }
         }
         this.main.getConnectionManager().isMapLoaded = true;
         this.main.getConnectionManager().dispatchSpacemapLoaded();
      }
      
      private function handleClipLoaded(param1:Event) : void
      {
         if(this.minimapManager.getMiniMap())
         {
            this.minimapManager.getMiniMap().redrawEntities();
         }
      }
      
      public function loadMusic() : void
      {
         AudioManager.loadMusic(this.musicTypeID);
      }
      
      public function showMap() : void
      {
      }
      
      public function onFileLoadError(param1:FileCollectionFileLoadEvent) : void
      {
      }
      
      public function getMapID() : int
      {
         return this.mapID;
      }
      
      public function getGameserverIP() : String
      {
         return this.gameserverIP;
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:SWFFinisher = null;
         TooltipControl.getInstance().hideAllToolTips();
         this.main.screenManager.removeRenderFrameListener();
         this.main.getGuiManager().removeAllCooldowns();
         this.eventManager.cleanup();
         this.minimapManager.cleanup();
         this.backgroundManager.cleanup();
         this.meteorManager.cleanup();
         this.main.screenManager.removeStarfield();
         this.combatManager.cleanup();
         this.droneManager.cleanup();
         this.shipManager.cleanup();
         this.nebulaManager.cleanup();
         this.portalManager.cleanup();
         this.lensflareManager.cleanup();
         this.planetManager.cleanup();
         this.stationManager.cleanup();
         this.collectableManager.cleanup();
         this.poiManager.cleanup();
         this.mineManager.cleanup();
         this.ctbManager.cleanup();
         if(Settings.unloadResources)
         {
            _loc1_ = 0;
            while(_loc1_ < this.finisherList.length)
            {
               _loc2_ = this.finisherList[_loc1_];
               _loc2_.clear();
               _loc1_++;
            }
            this.finisherList = [];
         }
         BitmapClip.clearCache();
         this.main.screenManager.addRenderFrameListener();
      }
      
      public function getScaleFactor() : Number
      {
         return this.scaleFactor;
      }
      
      public function getNeighbours() : Array
      {
         return this.neighbours;
      }
      
      public function getBackgroundManager() : BackgroundManager
      {
         return this.backgroundManager;
      }
      
      public function getShipManager() : ShipManager
      {
         return this.shipManager;
      }
      
      public function getNebulaManager() : NebulaManager
      {
         return this.nebulaManager;
      }
      
      public function getPlanetManager() : PlanetManager
      {
         return this.planetManager;
      }
      
      public function getLensflareManager() : LensflareManager
      {
         return this.lensflareManager;
      }
      
      public function getMain() : Main
      {
         return this.main;
      }
      
      public function getMinimapManager() : MinimapManager
      {
         return this.minimapManager;
      }
      
      public function getDroneManager() : DroneManager
      {
         return this.droneManager;
      }
      
      public function getCollectableManager() : CollectableManager
      {
         return this.collectableManager;
      }
      
      public function getCombatManager() : CombatManager
      {
         return this.combatManager;
      }
      
      public function getEventManager() : EventManager
      {
         return this.eventManager;
      }
      
      public function getStationManager() : StationManager
      {
         return this.stationManager;
      }
      
      public function getMineManager() : MineManager
      {
         return this.mineManager;
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function getPvpAllowed() : Boolean
      {
         return this.pvpAllowed;
      }
      
      public function setPvpAllowed(param1:int) : void
      {
         this.pvpAllowed = Boolean(param1);
      }
      
      public function setHomeMapFaction(param1:int) : void
      {
         this.homeMapFaction = param1;
      }
      
      public function getHomeMapFaction() : int
      {
         return this.homeMapFaction;
      }
      
      public function addFinisherToList(param1:SWFFinisher) : void
      {
         var _loc3_:SWFFinisher = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.finisherList.length)
         {
            _loc3_ = this.finisherList[_loc2_];
            if(_loc3_ == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.finisherList.push(param1);
      }
      
      public function getCtbManager() : CTBManager
      {
         return this.ctbManager;
      }
      
      public function getFireworksManager() : FireworksManager
      {
         return this.fireworksManager;
      }
      
      public function getCurrentStarSystemIndex() : int
      {
         var _loc1_:int = -1;
         if(this.mapID > 0 && this.mapID < 16)
         {
            _loc1_ = 0;
         }
         else if(this.mapID > 15 && this.mapID < 30)
         {
            _loc1_ = 1;
         }
         return _loc1_;
      }
   }
}

