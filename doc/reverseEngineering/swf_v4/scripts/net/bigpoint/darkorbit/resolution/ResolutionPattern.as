package net.bigpoint.darkorbit.resolution
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.pattern.CustomPattern;
   
   public class ResolutionPattern extends CustomPattern
   {
      
      private var _width:int;
      
      private var _height:int;
      
      private var _isSupported:Boolean;
      
      private var windowPatterns:Array;
      
      private var minimizedIconsPositions:Array;
      
      private var mainMenuPosition:Point;
      
      private var slotMenuPosition:Point;
      
      private var userSetting:Boolean = true;
      
      public function ResolutionPattern(param1:int, param2:int, param3:int)
      {
         super(param1);
         this._width = param2;
         this._height = param3;
         this.windowPatterns = [];
         this.minimizedIconsPositions = [];
      }
      
      public function addWindowPattern(param1:WindowPattern) : void
      {
         this.windowPatterns[int(param1.getPatternID())] = param1;
      }
      
      public function getWindowPattern(param1:int) : WindowPattern
      {
         return this.windowPatterns[int(param1)];
      }
      
      public function addMinimizedIconsPosition(param1:Point) : void
      {
         this.minimizedIconsPositions.push(param1);
      }
      
      public function getMinimizedIconsPosition(param1:int) : Point
      {
         return this.minimizedIconsPositions[param1];
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function getMainMenuPosition() : Point
      {
         return this.mainMenuPosition;
      }
      
      public function setMainMenuPosition(param1:Point) : void
      {
         this.mainMenuPosition = param1;
      }
      
      public function isUserSetting() : Boolean
      {
         return this.userSetting;
      }
      
      public function setUserSetting(param1:Boolean) : void
      {
         this.userSetting = param1;
      }
      
      public function getSlotMenuPosition() : Point
      {
         return this.slotMenuPosition;
      }
      
      public function setSlotMenuPosition(param1:Point) : void
      {
         this.slotMenuPosition = param1;
      }
      
      public function get isSupported() : Boolean
      {
         return this._isSupported;
      }
      
      public function set isSupported(param1:Boolean) : void
      {
         this._isSupported = param1;
      }
   }
}

