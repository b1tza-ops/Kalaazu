package net.bigpoint.darkorbit.mine
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.combat.CombatManager;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class MineManager
   {
      
      public static const logger:ILogger = Log.getLogger("MineManager");
      
      private var mines:Array = [];
      
      private var collectableLayer:Sprite;
      
      private var combatManager:CombatManager;
      
      private var animationTimer:Timer;
      
      private var animations:Array = [];
      
      private var moveTimer:Timer = new Timer(200);
      
      private var moveDelta:int = 12;
      
      private var clip:DisplayObject;
      
      private var timerStarted:Boolean = false;
      
      public function MineManager(param1:Sprite, param2:CombatManager)
      {
         super();
         this.combatManager = param2;
         this.collectableLayer = param1;
         this.animationTimer = new Timer(25,0);
         this.animationTimer.addEventListener(TimerEvent.TIMER,this.handleAnimationTimerTick);
         this.animationTimer.start();
      }
      
      public static function getRandomCount(param1:int, param2:int) : int
      {
         return param1 + Math.floor(Math.random() * (param2 - param1 + 1));
      }
      
      public function removeMine(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Mine = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:MinePattern = null;
         var _loc7_:ExplosionPattern = null;
         _loc3_ = 0;
         while(_loc3_ < this.mines.length)
         {
            _loc4_ = this.mines[_loc3_] as Mine;
            if(_loc4_.hash == param1)
            {
               _loc5_ = _loc4_.clip;
               if(_loc5_ != null)
               {
                  this.collectableLayer.removeChild(_loc5_);
                  this.removeFromAnimations(_loc5_);
                  ScreenManager.stopAnimation(_loc5_);
                  if(_loc4_.pulseClip != null)
                  {
                     ScreenManager.stopAnimation(_loc4_.pulseClip);
                     if(_loc5_ is BitmapClip)
                     {
                        (_loc5_ as BitmapClip).removeChild(_loc4_.pulseClip);
                     }
                     else if(_loc5_ is MovieClip)
                     {
                        (_loc5_ as MovieClip).removeChild(_loc4_.pulseClip);
                     }
                  }
               }
               if(param2)
               {
                  if(_loc4_.typeID == MinePattern.MINE_EMP01)
                  {
                     this.combatManager.addEMPtoMap(_loc4_.posX,_loc4_.posY);
                  }
                  else
                  {
                     _loc6_ = PatternManager.minePatterns[int(_loc4_.typeID)] as MinePattern;
                     _loc7_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_MINE_EXPLOSION,_loc6_.explodeType);
                     this.combatManager.showPyroEffect(_loc4_.posX,_loc4_.posY,_loc7_);
                     if(_loc4_.shockwaveColorID > 0)
                     {
                        this.combatManager.showShockwave(0,_loc4_.posX,_loc4_.posY,true);
                     }
                  }
               }
               this.mines.splice(_loc3_,1);
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function init() : void
      {
         var _loc1_:XML = Main.gameXML;
         if(_loc1_ == null)
         {
            Main.fatalError("game xml not loaded - terminating process");
         }
      }
      
      public function createMine(param1:String, param2:int, param3:int, param4:int, param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:Mine = new Mine(param2,param1,param3,param4,param5,param6);
         var _loc8_:MinePattern = PatternManager.minePatterns[int(param2)] as MinePattern;
         this.mines.push(_loc7_);
         if(ResourceManager.fileCollection.isLoaded(_loc8_.getResKey()))
         {
            this.attachClip(_loc7_,_loc8_);
         }
         else
         {
            ResourceManager.fileCollection.load(_loc8_.getResKey(),this.handleClipLoaded);
         }
      }
      
      private function attachClip(param1:Mine, param2:MinePattern) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MinePulsePattern = null;
         var _loc7_:ColorTransform = null;
         if(param2.useBitmapClip)
         {
            _loc3_ = new BitmapClip(ResourceManager.getMovieClip(param2.resKey,"mc"),param2.resKey);
         }
         else
         {
            _loc3_ = ResourceManager.getMovieClip(param2.resKey,"mc");
            MovieClip(_loc3_).mouseEnabled = Main.mouseEventsEnabled;
            MovieClip(_loc3_).mouseChildren = Main.mouseEventsEnabled;
         }
         if(!this.timerStarted && param2.shake)
         {
            this.moveTimer.addEventListener(TimerEvent.TIMER,this.moveMines);
            this.moveTimer.start();
            this.timerStarted = true;
         }
         _loc3_.x = param1.posX;
         _loc3_.y = param1.posY;
         if(_loc3_ is MovieClip)
         {
            _loc4_ = Math.random() * MovieClip(_loc3_).framesLoaded;
            MovieClip(_loc3_).gotoAndStop(_loc4_);
         }
         else if(_loc3_ is BitmapClip)
         {
            _loc4_ = Math.random() * BitmapClip(_loc3_).framesLoaded;
            BitmapClip(_loc3_).gotoAndStop(_loc4_);
         }
         this.animations.push(_loc3_);
         this.animations.push(_loc3_);
         param1.yMov = getRandomCount(0,this.moveDelta);
         param1.clip = _loc3_;
         _loc3_.alpha = 0;
         TweenLite.to(_loc3_,0.3,{
            "ease":Linear.easeNone,
            "alpha":1
         });
         if(param1.pulseColorId > 0 && !param2.hasStaticEffect)
         {
            _loc5_ = ResourceManager.getMovieClip("minePulse","mc");
            _loc6_ = PatternManager.minePulsePatterns[param1.pulseColorId] as MinePulsePattern;
            _loc7_ = new ColorTransform();
            _loc7_.color = _loc6_.color;
            _loc7_.alphaMultiplier = _loc6_.alpha;
            _loc5_.scaleX = _loc6_.scale;
            _loc5_.scaleY = _loc6_.scale;
            _loc5_.transform.colorTransform = _loc7_;
            param1.pulseClip = _loc5_;
            if(param2.useBitmapClip)
            {
               (_loc3_ as BitmapClip).addChild(_loc5_);
            }
            else
            {
               (_loc3_ as MovieClip).addChild(_loc5_);
            }
            this.playPulseAnimation(_loc5_,15);
         }
         this.collectableLayer.addChild(_loc3_);
      }
      
      private function playPulseAnimation(param1:MovieClip, param2:int) : void
      {
         var _loc3_:int = param1.framesLoaded;
         var _loc4_:Number = _loc3_ / param2;
         param1.gotoAndStop(1);
         TweenMax.to(param1,_loc4_,{
            "ease":Linear.easeNone,
            "frame":_loc3_,
            "repeat":-1
         });
      }
      
      private function handleClipLoaded(param1:SWFFinisher) : void
      {
         var _loc2_:Mine = null;
         var _loc3_:MinePattern = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.mines.length)
         {
            _loc2_ = this.mines[_loc4_];
            _loc3_ = PatternManager.minePatterns[int(_loc2_.typeID)] as MinePattern;
            if(_loc3_.getResKey() == param1.fileVO.id)
            {
               this.attachClip(_loc2_,_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function handleAnimationTimerTick(param1:TimerEvent) : void
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
      
      private function removeFromAnimations(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.animations.length)
         {
            _loc2_ = this.animations[_loc3_] as DisplayObject;
            if(param1 == _loc2_)
            {
               this.animations.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Mine = null;
         var _loc3_:DisplayObject = null;
         this.moveTimer.stop();
         this.moveTimer.removeEventListener(TimerEvent.TIMER,this.moveMines);
         _loc1_ = 0;
         while(_loc1_ < this.mines.length)
         {
            _loc2_ = this.mines[_loc1_] as Mine;
            _loc3_ = _loc2_.clip;
            if(_loc3_ != null)
            {
               this.collectableLayer.removeChild(_loc3_);
               ScreenManager.stopAnimation(_loc3_);
               if(_loc2_.pulseClip != null)
               {
                  ScreenManager.stopAnimation(_loc2_.pulseClip);
                  if(_loc3_ is BitmapClip)
                  {
                     (_loc3_ as BitmapClip).removeChild(_loc2_.pulseClip);
                  }
                  else if(_loc3_ is MovieClip)
                  {
                     (_loc3_ as MovieClip).removeChild(_loc2_.pulseClip);
                  }
               }
            }
            _loc1_++;
         }
         this.mines = [];
      }
      
      private function moveMines(param1:TimerEvent) : void
      {
         var _loc4_:Mine = null;
         var _loc2_:int = int(this.mines.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.mines[_loc3_];
            this.clip = _loc4_.clip;
            if(this.clip)
            {
               if(_loc4_.yMov < this.moveDelta)
               {
                  this.clip.y += _loc4_.moveSpeed;
                  ++_loc4_.yMov;
               }
               else
               {
                  _loc4_.yMov = 0;
                  _loc4_.moveSpeed = ~_loc4_.moveSpeed + 1;
               }
            }
            _loc3_++;
         }
      }
   }
}

