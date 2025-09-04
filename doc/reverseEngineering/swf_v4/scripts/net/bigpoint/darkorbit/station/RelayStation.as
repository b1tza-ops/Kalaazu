package net.bigpoint.darkorbit.station
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.lazyload.AssetLazyLoader;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class RelayStation extends MovieClip
   {
      
      private static var logger:ILogger = Log.getLogger("RelayStation");
      
      public static var filter:GlowFilter = new GlowFilter(0,1,2,2,50,3);
      
      private var finisher:SWFFinisher;
      
      private var station:MovieClip;
      
      public var relayID:int;
      
      public var relayName:String;
      
      public var posX:Number;
      
      public var posY:Number;
      
      public var hitpoints:Number = 0;
      
      private var maxHitpoints:Number;
      
      private var map:Map;
      
      private var hitpointClip:Sprite = new Sprite();
      
      private var hitpointBackgroundClip:Sprite = new Sprite();
      
      public var clickRadius:int = 45;
      
      public var clickOffSetX:int = 0;
      
      public var clickOffSetY:int = 0;
      
      public var isSelected:Boolean = false;
      
      public var borderClip:MovieClip;
      
      public var healthStation:Station;
      
      private var loader:AssetLazyLoader;
      
      private var pattern:StationPattern;
      
      public function RelayStation(param1:int, param2:int, param3:String, param4:Number, param5:Number, param6:Map)
      {
         super();
         this.loader = new AssetLazyLoader();
         this.relayID = param1;
         this.relayName = param3;
         this.posX = param4;
         this.posY = param5;
         this.map = param6;
         this.pattern = PatternManager.stationPatterns[param2];
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.borderClip = MovieClip(this.finisher.getEmbededMovieClip("ship_border"));
         if(!ResourceManager.fileCollection.isLoaded(this.pattern.resKey))
         {
            this.loader.addEventListener(AssetLazyLoader.ASSET_LOADED,this.createRelay);
            this.loader.loadAsset(this.pattern.resKey);
         }
         else
         {
            this.createRelay(null);
         }
      }
      
      private function createRelay(param1:Event) : void
      {
         this.finisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(this.pattern.resKey));
         this.station = this.finisher.getEmbededMovieClip("mc");
         this.station.glow.alpha = 0;
         this.borderClip.visible = false;
         this.borderClip.gotoAndStop(1);
         addChild(this.station);
         this.createHitpointBarContainers();
         this.map.getStationManager().assets.push(this);
         addChild(this.borderClip);
         this.createNickLabel();
      }
      
      private function createNickLabel() : void
      {
         var _loc1_:int = 16711680;
         var _loc2_:TextField = new TextField();
         var _loc3_:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc1_,Styles.nickFmt.bold);
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.embedFonts = Styles.nickEmbed;
         _loc2_.text = this.relayName.toString();
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.embedFonts = Styles.nickEmbed;
         addChild(_loc2_);
         _loc2_.x = -35;
         _loc2_.y = 45;
         _loc2_.filters = [filter];
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
      }
      
      private function createHitpointBarContainers() : void
      {
         this.hitpointBackgroundClip.graphics.lineStyle(1,0);
         this.hitpointBackgroundClip.graphics.beginFill(7171437);
         this.hitpointBackgroundClip.graphics.drawRect(0,0,50,3);
         this.hitpointBackgroundClip.graphics.endFill();
         this.hitpointBackgroundClip.x = -25;
         this.hitpointBackgroundClip.y = -30;
         this.addChild(this.hitpointClip);
         this.hitpointClip.graphics.lineStyle(1,0);
         this.hitpointClip.graphics.beginFill(4832832);
         this.hitpointClip.graphics.drawRect(0,0,50,3);
         this.hitpointClip.graphics.endFill();
         this.hitpointClip.x = -25;
         this.hitpointClip.y = 30;
         this.addChild(this.hitpointClip);
         this.setDamageBarVisibility(false);
      }
      
      public function setDamageBarVisibility(param1:Boolean) : void
      {
         this.hitpointBackgroundClip.visible = param1;
         this.hitpointClip.visible = param1;
      }
      
      public function toggleBorderClip(param1:Boolean) : void
      {
         this.borderClip.visible = param1;
      }
      
      public function setUpHitpoints(param1:int) : void
      {
         this.maxHitpoints = param1;
         this.setDamageBarVisibility(true);
      }
      
      public function updateHitpointBar(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this.hitpoints = param1;
         if(param2 != 0)
         {
            this.maxHitpoints = param2;
         }
         if(this.hitpoints == 0)
         {
            this.hitpointClip.width = 0;
            this.hitpointClip.visible = false;
         }
         else
         {
            this.hitpointClip.visible = true;
            _loc4_ = 50 / this.maxHitpoints * this.hitpoints;
            _loc5_ = 100 / this.maxHitpoints * this.hitpoints;
            if(param3)
            {
               TweenLite.to(this.hitpointClip,0.25,{"width":_loc4_});
               TweenLite.to(this.station.glow,0.25,{"alpha":_loc5_ / 100});
            }
            else
            {
               this.hitpointClip.width = _loc4_;
               this.station.glow.alpha = _loc5_ / 100;
            }
         }
      }
   }
}

