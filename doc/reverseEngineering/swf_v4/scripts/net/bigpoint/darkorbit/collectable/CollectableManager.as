package net.bigpoint.darkorbit.collectable
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.StickyToolTipHook;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.gui.CollectableReplacementIcon;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class CollectableManager
   {
      
      public static var loot_ore_keys:Array = ["ore_prometium","ore_endurium","ore_terbium","ore_xenomit","ore_prometid","ore_duranium","ore_promerium"];
      
      private var lastSelectedHash:String;
      
      private var resourceQueue:Array = [];
      
      private var collectables:Array = [];
      
      private var beacons:Array = [];
      
      private var honeyBoxes:Dictionary = new Dictionary();
      
      private var animationTimer:Timer;
      
      private var animations:Array = [];
      
      private var map:Map;
      
      public function CollectableManager(param1:Map)
      {
         super();
         this.map = param1;
         this.honeyBoxes["ozims"] = true;
         this.honeyBoxes["1604u"] = true;
         this.honeyBoxes["znmjs"] = true;
         this.honeyBoxes["bu9m9"] = true;
         this.honeyBoxes["zel71"] = true;
         this.honeyBoxes["q4knx"] = true;
         this.honeyBoxes["ci7m0"] = true;
         this.honeyBoxes["1ukl6"] = true;
         this.honeyBoxes["1gtlm"] = true;
         this.honeyBoxes["180fk"] = true;
         this.honeyBoxes["13b44"] = true;
         this.honeyBoxes["ntr63"] = true;
         this.honeyBoxes["1lmf1"] = true;
         this.honeyBoxes["1r78f"] = true;
         this.honeyBoxes["1oloo"] = true;
         this.honeyBoxes["xixzz"] = true;
         this.honeyBoxes["13jaa"] = true;
         this.honeyBoxes["6dge9"] = true;
         this.honeyBoxes["m79jj"] = true;
         this.honeyBoxes["h0rbx"] = true;
         this.honeyBoxes["n5cwr"] = true;
         this.honeyBoxes["1hviz"] = true;
         this.honeyBoxes["1g4pv"] = true;
         this.honeyBoxes["1ss4t"] = true;
         this.honeyBoxes["1c2tu"] = true;
         this.honeyBoxes["100vp"] = true;
         this.honeyBoxes["rku9c"] = true;
         this.honeyBoxes["1hd2h"] = true;
         this.honeyBoxes["416n4"] = true;
         this.honeyBoxes["1t5p4"] = true;
         this.honeyBoxes["6ovbk"] = true;
         this.honeyBoxes["3k2hr"] = true;
         this.honeyBoxes["48chq"] = true;
         this.honeyBoxes["lnkdf"] = true;
         this.honeyBoxes["1usjy"] = true;
         this.honeyBoxes["1scn2"] = true;
         this.honeyBoxes["usc1j"] = true;
         this.honeyBoxes["qj4o9"] = true;
         this.honeyBoxes["yyr28"] = true;
         this.honeyBoxes["3mtlo"] = true;
         this.honeyBoxes["hkw3g"] = true;
         this.honeyBoxes["a2abg"] = true;
         this.honeyBoxes["1fnxl"] = true;
         this.honeyBoxes["1kjds"] = true;
         this.honeyBoxes["9icg0"] = true;
         this.honeyBoxes["13umf"] = true;
         this.honeyBoxes["qtqry"] = true;
         this.honeyBoxes["1ucay"] = true;
         this.honeyBoxes["puvoe"] = true;
         this.honeyBoxes["1c3oi"] = true;
         this.honeyBoxes["1nesl"] = true;
         this.honeyBoxes["wl0wr"] = true;
         this.honeyBoxes["sn8n9"] = true;
         this.honeyBoxes["1v20m"] = true;
         this.honeyBoxes["1g568"] = true;
         this.honeyBoxes["1malf"] = true;
         this.honeyBoxes["w27x1"] = true;
         this.honeyBoxes["ov57p"] = true;
         this.honeyBoxes["1ecek"] = true;
         this.honeyBoxes["1my80"] = true;
         this.honeyBoxes["1srvg"] = true;
         this.honeyBoxes["2u942"] = true;
         this.honeyBoxes["103wa"] = true;
         this.honeyBoxes["1srrl"] = true;
         this.honeyBoxes["109xs"] = true;
         this.honeyBoxes["6x1u8"] = true;
         this.honeyBoxes["152g8"] = true;
         this.honeyBoxes["5naot"] = true;
         this.honeyBoxes["oeoud"] = true;
         this.honeyBoxes["tbeuu"] = true;
         this.honeyBoxes["13p97"] = true;
         this.honeyBoxes["rckbt"] = true;
         this.honeyBoxes["1trob"] = true;
         this.honeyBoxes["1fsi3"] = true;
         this.honeyBoxes["v2qxb"] = true;
         this.honeyBoxes["1szeq"] = true;
         this.honeyBoxes["87k2a"] = true;
         this.honeyBoxes["1bfcm"] = true;
         this.honeyBoxes["fc9f7"] = true;
         this.honeyBoxes["1g7du"] = true;
         this.honeyBoxes["lqzp9"] = true;
         this.honeyBoxes["wbku5"] = true;
         this.honeyBoxes["1ts89"] = true;
         this.honeyBoxes["1ag6n"] = true;
         this.honeyBoxes["10tv0"] = true;
         this.honeyBoxes["49ol8"] = true;
         this.honeyBoxes["1isk4"] = true;
         this.honeyBoxes["1jyqj"] = true;
         this.honeyBoxes["1e5au"] = true;
         this.honeyBoxes["8v03f"] = true;
         this.honeyBoxes["uy62u"] = true;
         this.honeyBoxes["mk797"] = true;
         this.honeyBoxes["1g65j"] = true;
         this.honeyBoxes["hm27v"] = true;
         this.honeyBoxes["hs940"] = true;
         this.honeyBoxes["q0e4a"] = true;
         this.honeyBoxes["bv8wq"] = true;
         this.honeyBoxes["1nad0"] = true;
         this.honeyBoxes["1mc48"] = true;
         this.honeyBoxes["1801q"] = true;
         this.animationTimer = new Timer(25,0);
         this.animationTimer.addEventListener(TimerEvent.TIMER,this.onAnimationTimer);
         this.animationTimer.start();
      }
      
      private function onAnimationTimer(param1:TimerEvent) : void
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in this.animations)
         {
            if(_loc2_ is MovieClip)
            {
               if(MovieClip(_loc2_).currentFrame == MovieClip(_loc2_).framesLoaded)
               {
                  MovieClip(_loc2_).gotoAndStop(1);
               }
               else
               {
                  MovieClip(_loc2_).nextFrame();
               }
            }
            else if(_loc2_ is BitmapClip)
            {
               if(BitmapClip(_loc2_).frame == BitmapClip(_loc2_).framesLoaded)
               {
                  BitmapClip(_loc2_).frame = 1;
               }
               else
               {
                  BitmapClip(_loc2_).frame = BitmapClip(_loc2_).frame + 1;
               }
            }
         }
      }
      
      public function removeCollectable(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Collectable = null;
         var _loc4_:DisplayObject = null;
         _loc2_ = 0;
         while(_loc2_ < this.collectables.length)
         {
            _loc3_ = this.collectables[_loc2_];
            if(_loc3_ != null && _loc3_.getHash() == param1)
            {
               if(this.lastSelectedHash != null)
               {
                  if(_loc3_.getHash() == this.lastSelectedHash)
                  {
                     this.setLastSelectedHash(null);
                  }
               }
               _loc4_ = _loc3_.clip;
               if(_loc3_.collectableClass == CollectablePattern.TYPE_ORE && _loc3_.tooltipHook != null && _loc3_.tooltipHook.toolTipVisible)
               {
                  _loc3_.tooltipHook.hideTooltip2();
               }
               if(_loc4_ != null)
               {
                  TweenLite.to(_loc4_,0.5,{
                     "ease":Linear.easeNone,
                     "alpha":0,
                     "onComplete":this.onRemoveMovieClip,
                     "onCompleteParams":[_loc4_]
                  });
               }
               this.collectables.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.beacons.length)
         {
            _loc3_ = this.beacons[_loc2_];
            if(_loc3_ != null && _loc3_.getHash() == param1)
            {
               if(this.lastSelectedHash != null)
               {
                  if(_loc3_.getHash() == this.lastSelectedHash)
                  {
                     this.setLastSelectedHash(null);
                  }
               }
               _loc4_ = _loc3_.clip;
               if(_loc4_ != null)
               {
                  TweenLite.to(_loc4_,0.5,{
                     "ease":Linear.easeNone,
                     "alpha":0,
                     "onComplete":this.onRemoveMovieClip,
                     "onCompleteParams":[_loc4_]
                  });
               }
               this.beacons.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function hitTest(param1:int, param2:int) : Collectable
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:Collectable = null;
         var _loc3_:int = 25;
         _loc5_ = 0;
         while(_loc5_ < this.beacons.length)
         {
            _loc6_ = this.beacons[_loc5_];
            _loc4_ = _loc6_.clip;
            if(_loc4_ == null)
            {
               return null;
            }
            if(_loc4_.x - _loc3_ < param1 && param1 < _loc4_.x + _loc3_ && _loc4_.y - _loc3_ < param2 && param2 < _loc4_.y + _loc3_)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.collectables.length)
         {
            _loc6_ = this.collectables[_loc5_];
            if(!(!Settings.displayResources && _loc6_.collectableClass == CollectablePattern.TYPE_ORE))
            {
               if(_loc6_.collectableClass != CollectablePattern.TYPE_FIREWORKS_BOX)
               {
                  _loc4_ = _loc6_.clip;
                  if(_loc4_ == null)
                  {
                     return null;
                  }
                  if(_loc4_.x - _loc3_ < param1 && param1 < _loc4_.x + _loc3_ && _loc4_.y - _loc3_ < param2 && param2 < _loc4_.y + _loc3_)
                  {
                     return _loc6_;
                  }
               }
            }
            _loc5_++;
         }
         return null;
      }
      
      public function mouseOverTest(param1:int, param2:int) : Boolean
      {
         var _loc4_:Collectable = null;
         var _loc5_:DisplayObject = null;
         var _loc3_:int = 25;
         var _loc6_:int = 0;
         while(_loc6_ < this.beacons.length)
         {
            _loc4_ = this.beacons[_loc6_];
            _loc5_ = _loc4_.clip;
            if(_loc5_ != null)
            {
               if(_loc5_.x - _loc3_ < param1 && param1 < _loc5_.x + _loc3_ && _loc5_.y - _loc3_ < param2 && param2 < _loc5_.y + _loc3_)
               {
                  return true;
               }
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < this.collectables.length)
         {
            _loc4_ = this.collectables[_loc6_];
            if(!(!Settings.displayResources && _loc4_.collectableClass == CollectablePattern.TYPE_ORE))
            {
               if(_loc4_.collectableClass != CollectablePattern.TYPE_FIREWORKS_BOX)
               {
                  _loc5_ = _loc4_.clip;
                  if(_loc5_ != null)
                  {
                     if(_loc5_.x - _loc3_ < param1 && param1 < _loc5_.x + _loc3_ && _loc5_.y - _loc3_ < param2 && param2 < _loc5_.y + _loc3_)
                     {
                        if(_loc4_.tooltipHook != null)
                        {
                           _loc4_.tooltipHook.showTooltip2();
                        }
                        return true;
                     }
                     if(_loc4_.tooltipHook != null && _loc4_.tooltipHook.toolTipVisible)
                     {
                        _loc4_.tooltipHook.hideTooltip2();
                     }
                  }
               }
            }
            _loc6_++;
         }
         return false;
      }
      
      public function setCollectableVisibility(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:Collectable = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.collectables.length)
         {
            _loc5_ = this.collectables[_loc4_];
            if(_loc5_.clip != null)
            {
               if(param1 == _loc5_.collectableClass)
               {
                  if(param2 == -1)
                  {
                     _loc5_.clip.visible = param3;
                  }
                  else if(_loc5_.getTypeID() == param2)
                  {
                     _loc5_.clip.visible = param3;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function showBeam(param1:Number, param2:Number, param3:int, param4:String) : void
      {
         var _loc5_:MovieClip = ResourceManager.getMovieClip(param4,"mc");
         _loc5_.x = param1;
         _loc5_.y = param2;
         this.map.getMain().screenManager.collectableLayer.addChild(_loc5_);
         _loc5_.gotoAndStop(1);
         var _loc6_:int = _loc5_.framesLoaded;
         TweenLite.to(_loc5_,param3 / 1000,{
            "ease":Linear.easeNone,
            "frame":_loc6_,
            "onComplete":this.onRemoveMovieClip,
            "onCompleteParams":[_loc5_]
         });
      }
      
      private function onRemoveMovieClip(param1:DisplayObject) : void
      {
         if(!(param1 is CollectableReplacementIcon))
         {
            this.removeFromAnimations(param1);
            ScreenManager.stopAnimation(param1);
         }
         this.map.getMain().screenManager.collectableLayer.removeChild(param1);
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Collectable = null;
         this.animationTimer.stop();
         this.animationTimer.removeEventListener(TimerEvent.TIMER,this.onAnimationTimer);
         _loc1_ = 0;
         while(_loc1_ < this.collectables.length)
         {
            _loc2_ = this.collectables[_loc1_];
            if(_loc2_.clip != null)
            {
               this.map.getMain().screenManager.collectableLayer.removeChild(_loc2_.clip);
            }
            _loc2_.removeClip();
            _loc1_++;
         }
         this.collectables = [];
         _loc1_ = 0;
         while(_loc1_ < this.beacons.length)
         {
            _loc2_ = this.beacons[_loc1_];
            if(_loc2_.clip != null)
            {
               this.map.getMain().screenManager.collectableLayer.removeChild(_loc2_.clip);
            }
            _loc2_.removeClip();
            _loc1_++;
         }
         this.beacons = [];
      }
      
      public function createCollectable(param1:int, param2:String, param3:int, param4:int, param5:int, param6:int = -1) : void
      {
         var _loc9_:String = null;
         if(this.honeyBoxes[param2] == true)
         {
            return;
         }
         var _loc7_:CollectablePattern = PatternManager.getCollectablePattern(param1,param3);
         if(_loc7_ == null)
         {
            return;
         }
         var _loc8_:Collectable = null;
         switch(param1)
         {
            case CollectablePattern.TYPE_BOX:
               _loc8_ = new Box(param3,_loc7_,param2,param4,param5);
               Box(_loc8_).remainingLootTime = param6;
               this.collectables.push(_loc8_);
               break;
            case CollectablePattern.TYPE_ORE:
               _loc8_ = new Ore(param3,_loc7_,param2,param4,param5);
               this.collectables.push(_loc8_);
               break;
            case CollectablePattern.TYPE_BEACON:
               _loc8_ = new Beacon(param3,_loc7_,param2,param4,param5);
               this.beacons.push(_loc8_);
               break;
            case CollectablePattern.TYPE_FIREWORKS_BOX:
               _loc8_ = new FireworkBox(param3,_loc7_,param2,param4,param5);
               this.collectables.push(_loc8_);
         }
         if(Settings.qualityCollectable == Settings.QUALITY_LOW && _loc7_.hasSimpleRapresentation)
         {
            _loc9_ = "replacementCollectables";
         }
         else
         {
            _loc9_ = _loc7_.getResKey();
         }
         if(ResourceManager.fileCollection.isLoaded(_loc9_))
         {
            this.attachClip(_loc8_,_loc9_);
         }
         else
         {
            this.loadCollectableResource(_loc9_);
         }
      }
      
      private function loadCollectableResource(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.resourceQueue.length)
         {
            if(this.resourceQueue[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.resourceQueue.push(param1);
         ResourceManager.fileCollection.load(param1,this.onClipLoaded);
      }
      
      private function attachClip(param1:Collectable, param2:String) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:OrePattern = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         if(Settings.qualityCollectable == Settings.QUALITY_LOW && param1.collectablePattern.hasSimpleRapresentation)
         {
            _loc3_ = new CollectableReplacementIcon(ResourceManager.getBitmap(param2,param1.collectablePattern.getResKey()));
         }
         else if(param1.collectablePattern.useBitmapClip)
         {
            _loc3_ = new BitmapClip(ResourceManager.getMovieClip(param2,"mc"),param2);
         }
         else
         {
            _loc3_ = ResourceManager.getMovieClip(param2,"mc");
            MovieClip(_loc3_).mouseEnabled = Main.mouseEventsEnabled;
            MovieClip(_loc3_).mouseChildren = Main.mouseEventsEnabled;
         }
         _loc3_.x = param1.getPosX();
         _loc3_.y = param1.getPosY();
         switch(param1.collectableClass)
         {
            case CollectablePattern.TYPE_FIREWORKS_BOX:
               break;
            case CollectablePattern.TYPE_BEACON:
               ScreenManager.playAnimation(_loc3_,30,true);
               break;
            case CollectablePattern.TYPE_BOX:
               if(!(_loc3_ is CollectableReplacementIcon))
               {
                  this.animations.push(_loc3_);
               }
               if(param1.getTypeID() == 0)
               {
                  _loc5_ = ResourceManager.getMovieClip("ui","piechart");
                  _loc5_.x = _loc3_.x;
                  _loc5_.y = _loc3_.y - _loc3_.height * 0.5;
                  this.map.getMain().screenManager.collectableLayer.addChild(_loc5_);
                  _loc6_ = Box(param1).remainingLootTime * 0.001;
                  TweenLite.to(_loc5_,_loc6_,{
                     "ease":Linear.easeNone,
                     "frame":_loc5_.framesLoaded,
                     "onComplete":this.handleFadeOutPiechart,
                     "onCompleteParams":[_loc5_]
                  });
               }
               break;
            case CollectablePattern.TYPE_ORE:
               _loc3_.visible = Settings.displayResources;
               if(_loc3_ is MovieClip)
               {
                  _loc7_ = Math.random() * MovieClip(_loc3_).framesLoaded;
                  MovieClip(_loc3_).gotoAndStop(_loc7_);
               }
               else if(_loc3_ is BitmapClip)
               {
                  _loc7_ = Math.random() * BitmapClip(_loc3_).framesLoaded;
                  BitmapClip(_loc3_).gotoAndStop(_loc7_);
               }
               if(!(_loc3_ is CollectableReplacementIcon))
               {
                  this.animations.push(_loc3_);
               }
               _loc4_ = PatternManager.orePatterns[int(param1.getTypeID())];
               param1.tooltipHook = new StickyToolTipHook(_loc3_,BPLocale.getText(_loc4_.languageKey),this.map.getMain().x,this.map.getMain().y,220);
         }
         param1.clip = _loc3_;
         _loc3_.alpha = 0;
         this.map.getMain().screenManager.collectableLayer.addChild(_loc3_);
         TweenLite.to(_loc3_,0.5,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      private function handleFadeOutPiechart(param1:MovieClip) : void
      {
         if(this.map != null && param1 != null)
         {
            TweenLite.to(param1,0.25,{
               "ease":Linear.easeNone,
               "alpha":0,
               "onComplete":this.handleRemovePiechart,
               "onCompleteParams":[param1]
            });
         }
      }
      
      private function handleRemovePiechart(param1:MovieClip) : void
      {
         if(this.map != null && param1 != null)
         {
            this.map.getMain().screenManager.collectableLayer.removeChild(param1);
         }
      }
      
      private function onClipLoaded(param1:SWFFinisher) : void
      {
         var _loc3_:Collectable = null;
         var _loc4_:CollectablePattern = null;
         var _loc5_:int = 0;
         var _loc2_:String = param1.fileVO.id;
         _loc5_ = 0;
         while(_loc5_ < this.resourceQueue.length)
         {
            if(this.resourceQueue[_loc5_] == _loc2_)
            {
               this.resourceQueue.splice(_loc5_,1);
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.collectables.length)
         {
            _loc3_ = this.collectables[_loc5_];
            _loc4_ = PatternManager.getCollectablePattern(_loc3_.collectableClass,_loc3_.getTypeID());
            if(_loc4_.getResKey() == _loc2_)
            {
               this.attachClip(_loc3_,_loc4_.getResKey());
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.beacons.length)
         {
            _loc3_ = this.beacons[_loc5_];
            _loc4_ = PatternManager.getCollectablePattern(_loc3_.collectableClass,_loc3_.getTypeID());
            if(_loc4_.getResKey() == _loc2_)
            {
               this.attachClip(_loc3_,_loc4_.getResKey());
            }
            _loc5_++;
         }
      }
      
      public function getCollectable(param1:String) : Collectable
      {
         var _loc3_:Collectable = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.collectables.length)
         {
            _loc3_ = this.collectables[_loc2_];
            if(_loc3_.getHash() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLastSelectedHash() : String
      {
         return this.lastSelectedHash;
      }
      
      public function setLastSelectedHash(param1:String) : void
      {
         this.lastSelectedHash = param1;
      }
      
      public function getCollectables() : Array
      {
         return this.collectables;
      }
      
      public function getBeacons() : Array
      {
         return this.beacons;
      }
      
      private function removeFromAnimations(param1:DisplayObject) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.animations.length)
         {
            _loc3_ = this.animations[_loc2_];
            if(param1 == _loc3_)
            {
               this.animations.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
   }
}

