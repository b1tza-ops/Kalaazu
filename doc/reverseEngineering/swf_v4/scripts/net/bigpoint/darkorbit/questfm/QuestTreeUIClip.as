package net.bigpoint.darkorbit.questfm
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class QuestTreeUIClip extends MovieClip implements IQuestTreeUIClip
   {
      
      public static const RUNNING:int = 1;
      
      public static const UPCOMING:int = 2;
      
      public static const COMPLETED:int = 3;
      
      protected var _runningIcon:DisplayObject;
      
      protected var _upcomingIcon:DisplayObject;
      
      protected var _completedIcon:DisplayObject;
      
      protected var _currentState:int = 0;
      
      protected var _currentUIElement:DisplayObject = new Bitmap();
      
      private var _id:int;
      
      private var _type:int;
      
      public function QuestTreeUIClip()
      {
         super();
      }
      
      public function init(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void
      {
         this._runningIcon = new Bitmap(param1);
         this._upcomingIcon = new Bitmap(param2);
         this._completedIcon = new Bitmap(param3);
         addChild(this._runningIcon);
         addChild(this._upcomingIcon);
         addChild(this._completedIcon);
         this._runningIcon.visible = false;
         this._upcomingIcon.visible = false;
         this._completedIcon.visible = false;
      }
      
      public function set state(param1:int) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         this._currentState = param1;
         this._currentUIElement.visible = false;
         switch(param1)
         {
            case RUNNING:
               this._currentUIElement = this._runningIcon;
               break;
            case UPCOMING:
               this._currentUIElement = this._upcomingIcon;
               break;
            case COMPLETED:
               this._currentUIElement = this._completedIcon;
         }
         this._currentUIElement.visible = true;
      }
      
      public function get state() : int
      {
         return this._currentState;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
   }
}

