package net.bigpoint.darkorbit.pattern
{
   import com.bigpoint.utils.BPLocale;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.AmmoPrice;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioPattern;
   import net.bigpoint.darkorbit.background.CustomBackgroundPattern;
   import net.bigpoint.darkorbit.collectable.CollectablePattern;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.combat.LaserPattern;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.drone.DronePattern;
   import net.bigpoint.darkorbit.mine.MinePattern;
   import net.bigpoint.darkorbit.mine.MinePulsePattern;
   import net.bigpoint.darkorbit.planet.PlanetPattern;
   import net.bigpoint.darkorbit.portal.PortalAssetPattern;
   import net.bigpoint.darkorbit.portal.PortalPattern;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.resolution.WindowPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.EnginePositionPattern;
   import net.bigpoint.darkorbit.ship.EngineSmokePattern;
   import net.bigpoint.darkorbit.ship.ExpansionPattern;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   import net.bigpoint.darkorbit.station.StationPattern;
   
   public class PatternManager
   {
      
      public static var preloaderPatterns:Array;
      
      public static var colorPatterns:Array;
      
      public static var videoWindowColorPatterns:Array;
      
      public static var nebulaPatterns:Array;
      
      public static var shipPatterns:Array;
      
      public static var expansionClasses:Array;
      
      public static var minePatterns:Array;
      
      public static var planetPatterns:Array;
      
      public static var dronePatterns:Array;
      
      public static var stationPatterns:Array;
      
      public static var portalPatterns:Array;
      
      public static var portalAssetPatterns:Vector.<PortalAssetPattern>;
      
      public static var laserClasses:Array;
      
      public static var muzzleFlashPatterns:Array;
      
      public static var rocketClasses:Array;
      
      public static var collectableClasses:Array;
      
      public static var meteorPatterns:Array;
      
      public static var minimapPatterns:Array;
      
      public static var backgroundPatterns:Array;
      
      public static var backgroundMaskPatterns:Array;
      
      public static var musicPatterns:Array;
      
      public static var pyroClasses:Array;
      
      public static var enginePatterns:Array;
      
      public static var engineSmokePatterns:Array;
      
      public static var rocketSmokePatterns:Array;
      
      public static var enginePositionClasses:Array;
      
      public static var robotPatterns:Array;
      
      public static var soundPatterns:Array;
      
      public static var shipGlowPatterns:Array;
      
      public static var lensflarePatterns:Array;
      
      public static var resolutionPatterns:Array;
      
      public static var boosterPatterns:Array;
      
      public static var orePatterns:Array;
      
      public static var supportedResolutionIds:Array;
      
      private static var easter:Boolean;
      
      public static var minePulsePatterns:Array;
      
      public static var hitpointColorPatterns:Array;
      
      public static var shockwavePatterns:Array;
      
      public static var fireworkPatterns:Array;
      
      public static var achievementPatterns:Array;
      
      public static var techDefaults:Array;
      
      public static var petGearPatterns:Array;
      
      public static var petBuffPatterns:Array;
      
      public static var effectPatterns:Array;
      
      public static var poizonePatterns:Vector.<PoizonePattern>;
      
      private static var preloaderTypeID:int = 0;
      
      public static var ammoPrices:Array = [];
      
      public static var bannerAdPatterns:Dictionary = new Dictionary();
      
      public function PatternManager()
      {
         super();
      }
      
      public static function parsePatterns(param1:XML) : void
      {
         easter = Main.parseBooleanFromString(param1.@easter);
         parsePreloaderPatterns(param1);
         parseDronePatterns(param1);
         parseStationPatterns(param1);
         parseShipPatterns(param1);
         parseExpansionPatterns(param1);
         parsePortalPatterns(param1);
         parsePortalAssetPatterns(param1);
         parseMinePatterns(param1);
         parseFireworkPatterns(param1);
         parseLaserPatterns(param1);
         parseLaserFlashPatterns(param1);
         parseRocketPatterns(param1);
         parsePlanetPatterns(param1);
         parseNebulaPatterns(param1);
         parseCollectablePatterns(param1);
         parseMeteorPatterns(param1);
         parseMinimapPatterns(param1);
         parseBackgroundPatterns(param1);
         parseBackgroundMaskPatterns(param1);
         parseMusicPatterns(param1);
         parseColorPatterns(param1);
         parseVideoWindowColorPatterns(param1);
         parsePyroPatterns(param1);
         parseShockwavePatterns(param1);
         parseEnginePatterns(param1);
         parseEngineSmokePatterns(param1);
         parseRocketSmokePatterns(param1);
         parseEnginePositionPatterns(param1);
         parseRobotPatterns(param1);
         parseSoundPatterns(param1);
         parseShipGlowPatterns(param1);
         parseLensflarePatterns(param1);
         parseResolutionPatterns(param1);
         parseBoosterPatterns(param1);
         parseOrePatterns(param1);
         parseMinePulsePatterns(param1);
         parseHitpointColorPatterns(param1);
         parseAchievementPatterns(param1);
         parseBannerAdPatterns(param1);
         parseTechDefaults(param1);
         parseGearPatterns(param1);
         parseBuffPatterns(param1);
         parseEffectPatterns(param1);
         parsePoizonePatterns(param1);
      }
      
      private static function parsePoizonePatterns(param1:XML) : void
      {
         var _loc2_:PoizonePattern = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:XML = null;
         poizonePatterns = new Vector.<PoizonePattern>();
         for each(_loc8_ in param1.patterns.poizones.poizone)
         {
            _loc3_ = int(_loc8_.@id);
            _loc4_ = _loc8_.@backgroundID;
            _loc5_ = _loc8_.@resKey;
            _loc6_ = int(_loc8_.@avWidth);
            _loc7_ = int(_loc8_.@avHeight);
            _loc2_ = new PoizonePattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
            while(_loc3_ > poizonePatterns.length)
            {
               poizonePatterns[poizonePatterns.length] = null;
            }
            poizonePatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parseEffectPatterns(param1:XML) : void
      {
         var _loc2_:EffectPattern = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:XML = null;
         effectPatterns = [];
         for each(_loc6_ in param1.patterns.effects.effect)
         {
            _loc3_ = int(_loc6_.@id);
            _loc4_ = _loc6_.@resKey;
            _loc2_ = new EffectPattern(_loc3_,_loc4_);
            effectPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parseBuffPatterns(param1:XML) : void
      {
         var _loc2_:BuffPattern = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         petBuffPatterns = [];
         for each(_loc7_ in param1.patterns.petBuffs.buff)
         {
            _loc3_ = int(_loc7_.@id);
            _loc4_ = _loc7_.@resKey;
            _loc5_ = _loc7_.@languageKey;
            _loc6_ = getEffectID(String(_loc7_.@effect));
            _loc2_ = new BuffPattern(_loc3_,_loc4_,_loc5_,_loc6_);
            petBuffPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function getEffectID(param1:String) : int
      {
         var _loc2_:int = 0;
         if(param1 == "")
         {
            _loc2_ = -1;
         }
         else
         {
            _loc2_ = int(param1);
         }
         return _loc2_;
      }
      
      private static function parseGearPatterns(param1:XML) : void
      {
         var _loc2_:GearPattern = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc12_:XML = null;
         petGearPatterns = [];
         var _loc10_:String = param1.patterns.petgears.@normalState;
         var _loc11_:String = param1.patterns.petgears.@activeState;
         for each(_loc12_ in param1.patterns.petgears.gear)
         {
            _loc3_ = int(_loc12_.@id);
            _loc7_ = _loc12_.@effectTarget;
            _loc8_ = _loc12_.@targetList;
            _loc9_ = _loc12_.@suffix;
            _loc6_ = BPLocale.getText("pet_gear_" + _loc12_.@name);
            _loc5_ = _loc12_.@resKey;
            _loc4_ = getEffectID(_loc12_.@effect);
            _loc2_ = new GearPattern(_loc3_,_loc6_,_loc5_,_loc4_,_loc10_,_loc11_,_loc8_,_loc9_);
            petGearPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parsePreloaderPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:PreloadPattern = null;
         preloaderPatterns = [];
         for each(_loc2_ in param1.patterns.preloadedResources.resource)
         {
            _loc3_ = _loc2_.@resKey;
            _loc4_ = false;
            if(_loc2_.@precache.length() > 0)
            {
               _loc4_ = Boolean(int(_loc2_.@precache));
            }
            _loc5_ = new PreloadPattern(preloaderTypeID,_loc3_,_loc4_);
            var _loc8_:*;
            preloaderPatterns[_loc8_ = preloaderTypeID++] = _loc5_;
         }
      }
      
      private static function parseBannerAdPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:BannerAdPattern = null;
         for each(_loc2_ in param1.patterns.bannerads.bannerad)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = String(_loc2_.@baseKey);
            _loc5_ = String(_loc2_.@enumName);
            _loc6_ = int(_loc2_.@assetCount);
            _loc7_ = new BannerAdPattern(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc2_.@footer.length() > 0)
            {
               _loc7_.footerKey = "bannerad_footer_" + String(_loc2_.@footer);
            }
            bannerAdPatterns[_loc5_] = _loc7_;
         }
      }
      
      private static function parseTechDefaults(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TechDefault = null;
         techDefaults = [];
         for each(_loc2_ in param1.patterns.techs.tech)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = String(_loc2_.@linkageID);
            _loc5_ = new TechDefault(_loc3_,_loc4_);
            if(_loc2_.@hasDuration.length() > 0)
            {
               _loc5_.hasDuration = Main.parseBooleanFromString(String(_loc2_.@hasDuration));
            }
            techDefaults[_loc3_] = _loc5_;
         }
      }
      
      public static function parseSpecialOfferPrices(param1:XMLList) : void
      {
         var _loc3_:BannerAdPattern = null;
         var _loc4_:String = null;
         var _loc5_:XML = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc2_:Array = [];
         for each(_loc3_ in bannerAdPatterns)
         {
            _loc2_[_loc3_.id] = _loc3_;
         }
         for each(_loc5_ in param1)
         {
            _loc6_ = int(_loc5_.@id);
            _loc7_ = Number(_loc5_.@price);
            _loc4_ = String(_loc5_.@currency);
            if(_loc2_[_loc6_] != undefined)
            {
               (_loc2_[_loc6_] as BannerAdPattern).price = _loc7_;
            }
         }
         Settings.currency = _loc4_;
      }
      
      private static function parseResolutionPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ResolutionPattern = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:WindowPattern = null;
         resolutionPatterns = [];
         for each(_loc2_ in param1.patterns.resolutions.resolution)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int(_loc2_.@width);
            _loc5_ = int(_loc2_.@height);
            _loc6_ = new ResolutionPattern(_loc3_,_loc4_,_loc5_);
            _loc7_ = int(_loc2_.minimizedIconSlots.@x);
            _loc8_ = int(_loc2_.minimizedIconSlots.@y);
            if(_loc2_.@userSetting.length() > 0)
            {
               _loc6_.setUserSetting(Boolean(int(_loc2_.@userSetting)));
            }
            for each(_loc9_ in _loc2_.minimizedIconSlots.minimizedIconSlot)
            {
               _loc11_ = int(_loc9_.@iconXPos) + _loc7_;
               _loc12_ = int(_loc9_.@iconYPos) + _loc8_;
               _loc6_.addMinimizedIconsPosition(new Point(_loc11_,_loc12_));
            }
            for each(_loc10_ in _loc2_.windows.window)
            {
               _loc13_ = int(_loc10_.@id);
               _loc14_ = _loc10_.@xPos;
               _loc15_ = _loc10_.@yPos;
               _loc16_ = new WindowPattern(_loc13_);
               if(_loc14_ == "center")
               {
                  _loc16_.setCenterHorizontal();
               }
               else
               {
                  _loc16_.setXPos(int(_loc14_));
               }
               if(_loc15_ == "center")
               {
                  _loc16_.setCenterVertical();
               }
               else
               {
                  _loc16_.setYPos(int(_loc15_));
               }
               _loc6_.addWindowPattern(_loc16_);
            }
            _loc6_.setMainMenuPosition(new Point(int(_loc2_.@mainMenuXPos),int(_loc2_.@mainMenuYPos)));
            _loc6_.setSlotMenuPosition(new Point(int(_loc2_.@slotMenuXPos),int(_loc2_.@slotMenuYPos)));
            resolutionPatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseBoosterPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         boosterPatterns = [];
         for each(_loc2_ in param1.patterns.boosters.booster)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int(_loc2_.@infoFieldID);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = _loc2_.@barKey;
            boosterPatterns[int(_loc3_)] = new BoosterPattern(_loc3_,_loc4_,_loc5_,_loc6_);
         }
      }
      
      private static function parseHitpointColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         hitpointColorPatterns = [];
         for each(_loc2_ in param1.hitpointColors.hitpointColor)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int("0x" + _loc2_.@code);
            hitpointColorPatterns[int(_loc3_)] = _loc4_;
         }
      }
      
      private static function parseOrePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:OrePattern = null;
         orePatterns = [];
         for each(_loc2_ in param1.patterns.ores.ore)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = _loc2_.@languageKey;
            _loc6_ = new OrePattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@refiner.length() > 0)
            {
               _loc6_.parseRefiners(_loc2_.@refiner);
            }
            orePatterns[int(_loc3_)] = _loc6_;
         }
      }
      
      private static function parseAchievementPatterns(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:AchievementPattern = null;
         achievementPatterns = [];
         var _loc2_:int = 0;
         for each(_loc3_ in param1.patterns.achievements.achievement)
         {
            _loc4_ = int(_loc3_.@id);
            _loc2_++;
            _loc5_ = _loc3_.@languageKey;
            _loc6_ = new AchievementPattern(_loc4_,_loc5_);
            achievementPatterns[int(_loc4_)] = _loc6_;
         }
         AchievementPattern.MAX_ID = _loc2_;
      }
      
      private static function parseStationPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         stationPatterns = [];
         for each(_loc2_ in param1.patterns.stations.station)
         {
            _loc3_ = int(_loc2_.@factionID);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@width);
            _loc6_ = int(_loc2_.@height);
            stationPatterns[_loc3_] = new StationPattern(_loc3_,_loc4_,_loc5_,_loc6_);
         }
      }
      
      private static function parseShipPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:ShipPattern = null;
         var _loc6_:int = 0;
         var _loc7_:PreloadPattern = null;
         shipPatterns = [];
         for each(_loc2_ in param1.patterns.ships.ship)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new ShipPattern(_loc3_,_loc4_);
            if(_loc2_.@loopPlay.length() > 0)
            {
               _loc5_.setPlayLoop(Main.parseBooleanFromString(_loc2_.@loopPlay));
            }
            if(_loc2_.@laserClassID.length() > 0)
            {
               _loc5_.setLaserClassID(int(_loc2_.@laserClassID));
            }
            if(_loc2_.@rocketClassID.length() > 0)
            {
               _loc5_.setRocketClassID(int(_loc2_.@rocketClassID));
            }
            if(_loc2_.@expansionClassID.length() > 0)
            {
               _loc5_.setExpansionClassID(int(_loc2_.@expansionClassID));
            }
            if(_loc2_.@labelVisible.length() > 0)
            {
               _loc5_.setLabelVisibility(Main.parseBooleanFromString(_loc2_.@labelVisible));
            }
            if(_loc2_.@labelYOffset.length() > 0)
            {
               _loc5_.setLabelYOffset(int(_loc2_.@labelYOffset));
            }
            if(_loc2_.@energyVisible.length() > 0)
            {
               _loc5_.setEnergyVisibility(Main.parseBooleanFromString(_loc2_.@energyVisible));
            }
            if(_loc2_.@energyYOffset.length() > 0)
            {
               _loc5_.setEnergyYOffset(int(_loc2_.@energyYOffset));
            }
            if(_loc2_.@selectionYOffset.length() > 0)
            {
               _loc5_.setSelectionYOffset(int(_loc2_.@selectionYOffset));
            }
            if(_loc2_.@explodeTypeID.length() > 0)
            {
               _loc5_.setExplodeTypeID(int(_loc2_.@explodeTypeID));
            }
            if(_loc2_.@laserDamageTypeID.length() > 0)
            {
               _loc5_.setLaserDamageType(int(_loc2_.@laserDamageTypeID));
            }
            if(_loc2_.@rocketDamageTypeID.length() > 0)
            {
               _loc5_.setRocketDamageTypeID(int(_loc2_.@rocketDamageTypeID));
            }
            if(_loc2_.@engineTypeID.length() > 0)
            {
               _loc5_.setEngineTypeID(int(_loc2_.@engineTypeID));
            }
            if(_loc2_.@shockwaveID.length() > 0)
            {
               _loc5_.shockwaveID = int(_loc2_.@shockwaveID);
            }
            if(_loc2_.@spaceball.length() > 0)
            {
               _loc5_.setSpaceball(Main.parseBooleanFromString(_loc2_.@spaceball));
            }
            if(_loc2_.@engineSmokeID.length() > 0)
            {
               _loc5_.setEngineSmokeID(int(_loc2_.@engineSmokeID));
            }
            if(_loc2_.@enginePositionClassID.length() > 0)
            {
               _loc5_.setEnginePositionClassID(int(_loc2_.@enginePositionClassID));
            }
            if(_loc2_.@glowID.length() > 0)
            {
               _loc5_.setGlowID(int(_loc2_.@glowID));
            }
            if(_loc2_.@moveRadius.length() > 0)
            {
               _loc6_ = int(_loc2_.@moveRadius);
               _loc5_.moveRadiusSquared = _loc6_ * _loc6_;
            }
            if(_loc2_.@preload.length() > 0)
            {
               _loc5_.setPreload(Main.parseBooleanFromString(_loc2_.@preload));
            }
            if(_loc2_.@precache.length() > 0)
            {
               _loc5_.setPrecache(Main.parseBooleanFromString(_loc2_.@precache));
            }
            if(_loc2_.@unload.length() > 0)
            {
               _loc5_.setUnload(Main.parseBooleanFromString(_loc2_.@unload));
            }
            if(_loc2_.@clickRadius.length() > 0)
            {
               _loc5_.setClickRadius(int(_loc2_.@clickRadius));
            }
            if(_loc2_.@clickOffsetX.length() > 0)
            {
               _loc5_.setClickOffsetX(int(_loc2_.@clickOffsetX));
            }
            if(_loc2_.@clickOffsetY.length() > 0)
            {
               _loc5_.setClickOffsetY(int(_loc2_.@clickOffsetY));
            }
            if(_loc2_.@seekInterval.length() > 0)
            {
               _loc5_.setSeekInterval(int(_loc2_.@seekInterval));
            }
            if(_loc2_.@megaExplosion.length() > 0)
            {
               _loc5_.megaExplosion = Main.parseBooleanFromString(_loc2_.@megaExplosion);
            }
            if(_loc2_.@showCrap.length() > 0)
            {
               _loc5_.showCrap = Main.parseBooleanFromString(_loc2_.@showCrap);
            }
            if(_loc2_.@showPilot.length() > 0)
            {
               _loc5_.showPilot = int(_loc2_.@showPilot);
            }
            if(_loc2_.@pilotDistance.length() > 0)
            {
               _loc5_.pilotDistance = int(_loc2_.@pilotDistance);
            }
            if(_loc2_.@rotatable.length() > 0)
            {
               _loc5_.rotatable = Main.parseBooleanFromString(_loc2_.@rotatable);
            }
            if(_loc2_.@iconClassID.length() > 0)
            {
               _loc5_.iconClassID = int(_loc2_.@iconClassID);
            }
            else
            {
               _loc5_.iconClassID = _loc3_;
            }
            shipPatterns[_loc3_] = _loc5_;
            if(Settings.qualityShip == Settings.QUALITY_HIGH && Settings.preloadUserShips && _loc5_.isPreload())
            {
               _loc7_ = new PreloadPattern(preloaderTypeID,_loc4_,_loc5_.isPrecache());
               var _loc10_:*;
               preloaderPatterns[_loc10_ = preloaderTypeID++] = _loc7_;
            }
         }
      }
      
      private static function parseShipGlowPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:ResourcePattern = null;
         var _loc6_:PreloadPattern = null;
         shipGlowPatterns = [];
         for each(_loc2_ in param1.patterns.shipGlows.shipGlow)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new ResourcePattern(_loc3_,_loc4_);
            shipGlowPatterns[_loc3_] = _loc5_;
            if(_loc5_.isPreload())
            {
               _loc6_ = new PreloadPattern(preloaderTypeID,_loc4_,_loc5_.isPrecache());
               var _loc9_:*;
               preloaderPatterns[_loc9_ = preloaderTypeID++] = _loc6_;
            }
         }
      }
      
      private static function parsePortalPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PortalPattern = null;
         portalPatterns = [];
         for each(_loc2_ in param1.patterns.portals.portal)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@width);
            _loc6_ = int(_loc2_.@height);
            _loc7_ = new PortalPattern(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc7_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@tdm.length() > 0)
            {
               _loc7_.setTDM(Main.parseBooleanFromString(_loc2_.@tdm));
            }
            portalPatterns[_loc3_] = _loc7_;
         }
      }
      
      private static function parsePortalAssetPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:PortalAssetPattern = null;
         portalAssetPatterns = new Vector.<PortalAssetPattern>();
         for each(_loc2_ in param1.patterns.portalAssets.portalAsset)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new PortalAssetPattern(_loc3_,_loc4_);
            while(_loc3_ > portalAssetPatterns.length)
            {
               portalAssetPatterns[portalAssetPatterns.length] = null;
            }
            portalAssetPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseMinePatterns(param1:XML) : void
      {
         var _loc2_:MinePattern = null;
         var _loc3_:int = 0;
         var _loc4_:XML = null;
         minePatterns = [];
         for each(_loc4_ in param1.patterns.mines.mine)
         {
            _loc3_ = int(_loc4_.@id);
            _loc2_ = new MinePattern(_loc3_,_loc4_.@resKey);
            if(_loc4_.@explodeType.length() > 0)
            {
               _loc2_.explodeType = int(_loc4_.@explodeType);
            }
            if(_loc4_.@useBitmapClip.length() > 0)
            {
               _loc2_.useBitmapClip = Main.parseBooleanFromString(_loc4_.@useBitmapClip);
            }
            if(_loc4_.@hasStaticEffect.length() > 0)
            {
               _loc2_.hasStaticEffect = Main.parseBooleanFromString(_loc4_.@hasStaticEffect);
            }
            if(_loc4_.@shake.length() > 0)
            {
               _loc2_.shake = Main.parseBooleanFromString(_loc4_.@shake);
            }
            minePatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parseFireworkPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:FireworkPattern = null;
         fireworkPatterns = [];
         for each(_loc2_ in param1.patterns.fireworks.firework)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int(_loc2_["class"]);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = new FireworkPattern(_loc4_,_loc3_,_loc5_);
            if(_loc2_.@useBitmapClip.length() > 0)
            {
               _loc6_.useBitmapClip = Main.parseBooleanFromString(_loc2_.@useBitmapClip);
            }
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            fireworkPatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseMinePulsePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         minePulsePatterns = [];
         for each(_loc2_ in param1.patterns.minePulseColors.minePulseColor)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = uint("0x" + _loc2_.@color);
            _loc6_ = Number(_loc2_.@alpha);
            _loc7_ = Number(_loc2_.@scale);
            minePulsePatterns[_loc3_] = new MinePulsePattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         }
      }
      
      private static function parseLaserPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:LaserPattern = null;
         laserClasses = [];
         for each(_loc2_ in param1.patterns.lasers.laser)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!laserClasses[_loc3_])
            {
               laserClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@type);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = int(_loc2_.@fireRate);
            _loc7_ = new LaserPattern(_loc3_,_loc4_,_loc5_,_loc6_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc7_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@laserFlashID.length() > 0)
            {
               _loc7_.setLaserFlashID(int(_loc2_.@laserFlashID));
            }
            if(_loc2_.@laserLength.length() > 0)
            {
               _loc7_.laserLength = int(_loc2_.@laserLength);
            }
            if(_loc2_.@absorber.length() > 0)
            {
               _loc7_.setAbsorber(Main.parseBooleanFromString(_loc2_.@absorber));
            }
            if(_loc2_.@speed.length() > 0)
            {
               _loc7_.setSpeed(_loc2_.@speed);
            }
            if(_loc2_.@playLoop.length() > 0)
            {
               _loc7_.setPlayLoop(Main.parseBooleanFromString(_loc2_.@playLoop));
            }
            if(_loc2_.@playLoopRotated.length() > 0)
            {
               _loc7_.setPlayLoopRotated(Main.parseBooleanFromString(_loc2_.@playLoopRotated));
            }
            if(_loc2_.@attackLength.length() > 0)
            {
               _loc7_.setAttackLength(int(_loc2_.@attackLength));
            }
            if(_loc2_.@skillResKey.length() > 0)
            {
               _loc7_.skillResKey = _loc2_.@skillResKey;
            }
            laserClasses[_loc3_][_loc4_] = _loc7_;
         }
      }
      
      private static function parsePyroPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:ExplosionPattern = null;
         pyroClasses = [];
         for each(_loc2_ in param1.patterns.pyroEffects.pyroEffect)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!pyroClasses[_loc3_])
            {
               pyroClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@id);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = new ExplosionPattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@useBitmapClip.length() > 0)
            {
               _loc6_.useBitmapClip = Main.parseBooleanFromString(_loc2_.@useBitmapClip);
            }
            if(_loc2_.@precache.length() > 0)
            {
               _loc6_.precache = Main.parseBooleanFromString(_loc2_.@precache);
            }
            if(_loc2_.@displayShockwave.length() > 0)
            {
               _loc6_.displayShockwave = Main.parseBooleanFromString(_loc2_.@displayShockwave);
            }
            pyroClasses[_loc3_][_loc4_] = _loc6_;
         }
      }
      
      private static function parseShockwavePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:ShockwavePattern = null;
         shockwavePatterns = [];
         for each(_loc2_ in param1.patterns.shockwaves.shockwave)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@soundID);
            _loc6_ = new ShockwavePattern(_loc3_,_loc4_);
            _loc6_.setSoundID(_loc5_);
            if(_loc2_.@radius.length() > 0)
            {
               _loc6_.radius = _loc2_.@radius;
            }
            if(_loc2_.@duration.length() > 0)
            {
               _loc6_.duration = _loc2_.@duration;
            }
            if(_loc2_.@beginScale.length() > 0)
            {
               _loc6_.beginScale = _loc2_.@beginScale;
            }
            if(_loc2_.@endScale.length() > 0)
            {
               _loc6_.endScale = _loc2_.@endScale;
            }
            if(_loc2_.@maxShockwaves.length() > 0)
            {
               _loc6_.maxShockwaves = _loc2_.@maxShockwaves;
            }
            if(_loc2_.@shakeScreen.length() > 0)
            {
               _loc6_.shakeScreen = Main.parseBooleanFromString(_loc2_.@shakeScreen);
            }
            shockwavePatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseDronePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         dronePatterns = [];
         for each(_loc2_ in param1.patterns.drones.drone)
         {
            _loc3_ = int(_loc2_.@id);
            if(!dronePatterns[_loc3_])
            {
               dronePatterns[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@level);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = int(_loc2_.@droneRadius);
            dronePatterns[_loc3_][_loc4_] = new DronePattern(_loc3_,_loc5_,_loc4_,_loc6_);
         }
      }
      
      private static function parseExpansionPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:XML = null;
         var _loc6_:ExpansionPattern = null;
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:XML = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:PreloadPattern = null;
         expansionClasses = [];
         for each(_loc2_ in param1.patterns.expansions.expansion)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!expansionClasses[_loc3_])
            {
               expansionClasses[_loc3_] = [];
            }
            _loc4_ = new Dictionary();
            for each(_loc5_ in _loc2_.positionsList)
            {
               _loc4_[String(_loc5_.@name)] = parseCommaCoordinatesList(String(_loc5_.@data));
            }
            for each(_loc7_ in _loc2_.stage)
            {
               _loc8_ = int(_loc7_.@id);
               _loc9_ = [];
               for each(_loc10_ in _loc7_.salvo)
               {
                  _loc11_ = [];
                  _loc12_ = String(_loc10_.@laser).split(",");
                  _loc13_ = 0;
                  while(_loc13_ < _loc12_.length)
                  {
                     _loc11_[_loc13_] = _loc4_[_loc12_[_loc13_]];
                     _loc13_++;
                  }
                  _loc9_.push(_loc11_);
               }
               _loc6_ = new ExpansionPattern(_loc3_,_loc8_,String(_loc7_.@resKey),_loc9_);
               if(Settings.qualityShip == Settings.QUALITY_HIGH && Settings.preloadUserShips && _loc6_.resKey.length > 0)
               {
                  _loc6_.setPreload(true);
                  _loc14_ = new PreloadPattern(preloaderTypeID,_loc6_.resKey,false);
                  var _loc19_:*;
                  preloaderPatterns[_loc19_ = preloaderTypeID++] = _loc14_;
               }
               expansionClasses[_loc3_][_loc8_] = _loc6_;
            }
            expansionClasses[_loc3_][0] = expansionClasses[_loc3_][1];
         }
      }
      
      private static function parseCollectablePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:CollectablePattern = null;
         collectableClasses = [];
         for each(_loc2_ in param1.patterns.collectables.collectable)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!collectableClasses[_loc3_])
            {
               collectableClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@id);
            _loc5_ = null;
            if(easter && _loc2_.@easterResKey.length() > 0)
            {
               _loc5_ = _loc2_.@easterResKey;
            }
            else
            {
               _loc5_ = _loc2_.@resKey;
            }
            _loc6_ = new CollectablePattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@duration.length() > 0)
            {
               _loc6_.setDuration(int(_loc2_.@duration));
            }
            if(_loc2_.@objectPool.length() > 0)
            {
               _loc6_.hasObjectPool = Main.parseBooleanFromString(_loc2_.@objectPool);
            }
            if(_loc2_.@useBitmapClip.length() > 0)
            {
               _loc6_.useBitmapClip = Main.parseBooleanFromString(_loc2_.@useBitmapClip);
            }
            if(_loc2_.@precache.length() > 0)
            {
               _loc6_.precache = Main.parseBooleanFromString(_loc2_.@precache);
            }
            if(_loc2_.@hasSimpleRapresentation.length() > 0)
            {
               _loc6_.hasSimpleRapresentation = Main.parseBooleanFromString(_loc2_.@hasSimpleRapresentation);
            }
            if(_loc2_.@isHarvestable.length() > 0)
            {
               _loc6_.isHarvestable = Main.parseBooleanFromString(_loc2_.@isHarvestable);
            }
            collectableClasses[_loc3_][_loc4_] = _loc6_;
         }
      }
      
      private static function parseRocketPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:RocketPattern = null;
         rocketClasses = [];
         for each(_loc2_ in param1.patterns.rockets.rocket)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!rocketClasses[_loc3_])
            {
               rocketClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@id);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = new RocketPattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            rocketClasses[_loc3_][_loc4_] = _loc6_;
         }
      }
      
      private static function parseLaserFlashPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:ResourcePattern = null;
         muzzleFlashPatterns = [];
         for each(_loc2_ in param1.patterns.laserFlashes.laserFlash)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new ResourcePattern(_loc3_,_loc4_);
            muzzleFlashPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parsePlanetPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:PlanetPattern = null;
         planetPatterns = [];
         for each(_loc2_ in param1.patterns.planets.planet)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@radius);
            _loc6_ = new PlanetPattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@quarterPlanet.length() > 0)
            {
               _loc6_.setQuarterPlanet(Main.parseBooleanFromString(_loc2_.@quarterPlanet));
            }
            planetPatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseNebulaPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         nebulaPatterns = [];
         for each(_loc2_ in param1.patterns.nebulas.nebula)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            nebulaPatterns[_loc3_] = new ResourcePattern(_loc3_,_loc4_);
         }
      }
      
      private static function parseLensflarePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         lensflarePatterns = [];
         for each(_loc2_ in param1.patterns.lensflares.lensflare)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            lensflarePatterns[_loc3_] = new ResourcePattern(_loc3_,_loc4_);
         }
      }
      
      private static function parseMusicPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AudioPattern = null;
         musicPatterns = [];
         for each(_loc2_ in param1.patterns.music.track)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new AudioPattern(_loc3_,_loc4_);
            if(_loc2_.@volume.length() > 0)
            {
               _loc5_.setVolume(_loc2_.@volume);
            }
            musicPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseMeteorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         meteorPatterns = [];
         for each(_loc2_ in param1.patterns.meteors.meteor)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            meteorPatterns[_loc3_] = new ResourcePattern(_loc3_,_loc4_);
         }
      }
      
      private static function parseMinimapPatterns(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:XML = null;
         minimapPatterns = [];
         for each(_loc4_ in param1.patterns.minimaps.minimap)
         {
            _loc2_ = int(_loc4_.@type);
            _loc3_ = _loc4_.@resKey;
            minimapPatterns[_loc2_] = new ResourcePattern(_loc2_,_loc3_);
         }
      }
      
      private static function parseBackgroundPatterns(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:XML = null;
         var _loc13_:uint = 0;
         backgroundPatterns = [];
         for each(_loc12_ in param1.patterns.backgrounds.background)
         {
            _loc2_ = _loc12_.@content;
            _loc3_ = int(_loc12_.@type);
            if(_loc2_ == "resource")
            {
               _loc4_ = _loc12_.@resKey;
               _loc5_ = Main.parseBooleanFromString(_loc12_.@isTiled);
               _loc6_ = Main.parseBooleanFromString(_loc12_.@isReloadable);
               _loc7_ = int(_loc12_.@tileWidth);
               _loc8_ = int(_loc12_.@tileHeight);
               _loc11_ = _loc12_.@order;
               _loc9_ = int(_loc12_.@width);
               _loc10_ = int(_loc12_.@height);
               backgroundPatterns[_loc3_] = new BackgroundPattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc11_,_loc9_,_loc10_);
            }
            else if(_loc2_ == "custom")
            {
               _loc9_ = int(_loc12_.@width);
               _loc10_ = int(_loc12_.@height);
               _loc13_ = uint("0x" + _loc12_.@color);
               backgroundPatterns[_loc3_] = new CustomBackgroundPattern(_loc3_,_loc9_,_loc10_,_loc13_);
            }
         }
      }
      
      private static function parseBackgroundMaskPatterns(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:XML = null;
         backgroundMaskPatterns = [];
         for each(_loc4_ in param1.patterns.backgroundMasks.backgroundMask)
         {
            _loc2_ = int(_loc4_.@type);
            _loc3_ = _loc4_.@resKey;
            backgroundMaskPatterns[_loc2_] = new ResourcePattern(_loc2_,_loc3_);
         }
      }
      
      private static function parseColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         colorPatterns = [];
         for each(_loc2_ in param1.colors.color)
         {
            _loc3_ = _loc2_.@key;
            _loc4_ = _loc2_.@color;
            colorPatterns[_loc3_] = _loc4_;
         }
      }
      
      private static function parseVideoWindowColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         videoWindowColorPatterns = [];
         for each(_loc2_ in param1.colors.videoWindow.color)
         {
            _loc3_ = _loc2_.@key;
            _loc4_ = _loc2_.@color;
            videoWindowColorPatterns[_loc3_] = _loc4_;
         }
      }
      
      private static function parseEnginePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AudibleResourcePattern = null;
         enginePatterns = [];
         for each(_loc2_ in param1.patterns.engines.engine)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new AudibleResourcePattern(_loc3_,_loc4_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc5_.setSoundID(int(_loc2_.@soundID));
            }
            enginePatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseEngineSmokePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:EngineSmokePattern = null;
         engineSmokePatterns = [];
         for each(_loc2_ in param1.patterns.engineSmokes.engineSmoke)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new EngineSmokePattern(_loc3_,_loc4_);
            if(_loc2_.@rotation.length() > 0)
            {
               _loc5_.setRotation(Main.parseBooleanFromString(_loc2_.@rotation));
            }
            engineSmokePatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseRocketSmokePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:RocketSmokePattern = null;
         rocketSmokePatterns = [];
         for each(_loc2_ in param1.patterns.rocketSmokes.rocketSmoke)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@particleInterval);
            _loc6_ = Number(_loc2_.@particleDuration);
            _loc7_ = new RocketSmokePattern(_loc3_,_loc4_,_loc5_,_loc6_);
            rocketSmokePatterns[_loc3_] = _loc7_;
         }
      }
      
      private static function parseRobotPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         robotPatterns = [];
         for each(_loc2_ in param1.patterns.repairRobots.repairRobot)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            robotPatterns[_loc3_] = new ResourcePattern(_loc3_,_loc4_);
         }
      }
      
      private static function parseSoundPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AudioPattern = null;
         soundPatterns = [];
         for each(_loc2_ in param1.patterns.sounds.sound)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = _loc2_.@soundbank;
            _loc6_ = new AudioPattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@volume.length() > 0)
            {
               _loc6_.setVolume(_loc2_.@volume);
            }
            if(_loc2_.@loop.length() > 0)
            {
               _loc6_.setLoop(Main.parseBooleanFromString(_loc2_.@loop));
            }
            soundPatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseEnginePositionPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:XML = null;
         var _loc6_:EnginePositionPattern = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         enginePositionClasses = [];
         for each(_loc2_ in param1.patterns.enginePositions.enginePosition)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!enginePositionClasses[_loc3_])
            {
               enginePositionClasses[_loc3_] = [];
            }
            _loc4_ = new Dictionary();
            for each(_loc5_ in _loc2_.positionsList)
            {
               _loc4_[String(_loc5_.@name)] = parseCommaCoordinatesList(String(_loc5_.@data));
            }
            _loc7_ = [];
            for each(_loc8_ in _loc4_)
            {
               _loc7_.push(_loc8_);
            }
            _loc6_ = new EnginePositionPattern(_loc3_,_loc7_);
            enginePositionClasses[_loc3_] = _loc6_;
         }
      }
      
      public static function getLaserPattern(param1:int, param2:int) : LaserPattern
      {
         var _loc4_:LaserPattern = null;
         var _loc3_:Array = laserClasses[param1];
         if(_loc3_[int(param2)] == undefined)
         {
            _loc3_ = laserClasses[0];
            _loc4_ = _loc3_[int(param2)];
         }
         else
         {
            _loc4_ = _loc3_[int(param2)];
         }
         return _loc4_;
      }
      
      public static function getCollectablePattern(param1:int, param2:int) : CollectablePattern
      {
         var _loc3_:Array = collectableClasses[int(param1)];
         return _loc3_[int(param2)];
      }
      
      public static function getAmmoPrice(param1:int, param2:int) : AmmoPrice
      {
         var _loc3_:AmmoPrice = null;
         for each(_loc3_ in ammoPrices)
         {
            if(_loc3_.category == param1 && _loc3_.ammoID == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getExpansionPattern(param1:int, param2:int) : ExpansionPattern
      {
         var _loc3_:Array = expansionClasses[int(param1)];
         var _loc4_:ExpansionPattern = _loc3_[int(param2)];
         if(_loc4_ == null)
         {
            _loc4_ = _loc3_[0];
         }
         return _loc4_;
      }
      
      public static function getEnginePositionPattern(param1:int) : EnginePositionPattern
      {
         return enginePositionClasses[int(param1)];
      }
      
      public static function getPyroPattern(param1:int, param2:int) : ExplosionPattern
      {
         var _loc3_:Array = pyroClasses[int(param1)];
         return _loc3_[int(param2)];
      }
      
      public static function getMuzzleFlashPattern(param1:int) : ResourcePattern
      {
         return muzzleFlashPatterns[int(param1)];
      }
      
      public static function getRocketPattern(param1:int, param2:int) : RocketPattern
      {
         var _loc3_:Array = rocketClasses[int(param1)];
         return _loc3_[int(param2)];
      }
      
      public static function getDronePattern(param1:int, param2:int) : DronePattern
      {
         return dronePatterns[int(param1)][int(param2)];
      }
      
      private static function parseCommaCoordinatesList(param1:String) : Array
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_.push(new Point(_loc2_[_loc4_],_loc2_[_loc4_ + 1]));
            _loc4_ += 2;
         }
         return _loc3_;
      }
      
      public function getExpansionClasses() : Array
      {
         return expansionClasses;
      }
      
      public function getEnginePositionClasses() : Array
      {
         return enginePositionClasses;
      }
   }
}

