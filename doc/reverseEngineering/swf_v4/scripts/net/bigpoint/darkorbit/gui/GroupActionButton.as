package net.bigpoint.darkorbit.gui
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class GroupActionButton extends MovieClip
   {
      
      public static const TYPE_LEAVE:uint = 1;
      
      public static const TYPE_CHANGE_INVITATION_BEHAVIOR:int = 2;
      
      public static const TYPE_PING:uint = 3;
      
      public static const TYPE_FOLLOW:uint = 4;
      
      public static const TYPE_PROMOTE:uint = 5;
      
      public static const TYPE_KICK:uint = 6;
      
      public static const TYPE_IS_LEAD:uint = 7;
      
      public static const TYPE_INVITE:uint = 8;
      
      public static const TYPE_REJECT:uint = 9;
      
      public static const TYPE_ACCEPT:uint = 10;
      
      public static const TYPE_REVOKE:uint = 11;
      
      public static const TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL:uint = 12;
      
      public static const TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY:uint = 13;
      
      public static const TYPE_BLOCK_INVITATIONS:int = 14;
      
      public static const TYPE_ALLOW_INVITATIONS:int = 15;
      
      private var _type:int;
      
      private var _stdImage:Bitmap;
      
      private var _hoverImage:Bitmap;
      
      private var _disabledImage:Bitmap;
      
      private var _state:Boolean;
      
      private var _canHover:Boolean;
      
      private var _hoveringEnabled:Boolean;
      
      private var _enabled:Boolean = true;
      
      private var _verboseTypes:Array;
      
      private var _handleClick:Function;
      
      public function GroupActionButton()
      {
         super();
         this._stdImage = new Bitmap(new BitmapData(16,16,true,2298413311));
         addChild(this._stdImage);
         this._verboseTypes = [];
         this._verboseTypes[TYPE_KICK] = "kick";
         this._verboseTypes[TYPE_PROMOTE] = "promote";
         this._verboseTypes[TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL] = "inv_group";
         this._verboseTypes[TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY] = "inv_boss";
         this._verboseTypes[TYPE_LEAVE] = "leave";
         this._verboseTypes[TYPE_FOLLOW] = "follow";
         this._verboseTypes[TYPE_PING] = "ping";
         this._verboseTypes[TYPE_REJECT] = "rejectinv";
         this._verboseTypes[TYPE_ACCEPT] = "acceptinv";
         this._verboseTypes[TYPE_REVOKE] = "revokeinv";
         this._verboseTypes[TYPE_INVITE] = "sendinv";
         this._verboseTypes[TYPE_ALLOW_INVITATIONS] = "blockinv";
         this._verboseTypes[TYPE_BLOCK_INVITATIONS] = "allowinv";
      }
      
      public function toggle(param1:Boolean) : void
      {
         if(param1)
         {
            alpha = 1;
         }
         else
         {
            alpha = 0.5;
         }
      }
      
      public function init(param1:BitmapData, param2:BitmapData = null, param3:BitmapData = null) : void
      {
         if(contains(this._stdImage))
         {
            removeChild(this._stdImage);
         }
         this._stdImage = new Bitmap(param1.clone());
         if(param2 == null)
         {
            this._hoverImage = new Bitmap(param1.clone());
         }
         else
         {
            this._canHover = true;
            this._hoverImage = new Bitmap(param2.clone());
         }
         if(param3 == null)
         {
            this._disabledImage = new Bitmap(param1.clone());
         }
         else
         {
            this._disabledImage = new Bitmap(param3.clone());
         }
         addChild(this._stdImage);
         addChild(this._hoverImage);
         this._hoverImage.visible = false;
         addChild(this._disabledImage);
         this._disabledImage.visible = false;
         if(this._canHover)
         {
            this.enableHovering();
         }
      }
      
      private function enableHovering() : void
      {
         if(!this._hoveringEnabled)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
            this._hoveringEnabled = true;
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(this._hoverImage,0.5,{
            "alpha":0,
            "onComplete":this.setInvisible,
            "onCompleteParams":[this._hoverImage]
         });
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         this._hoverImage.alpha = 0;
         this._hoverImage.visible = true;
         TweenLite.to(this._hoverImage,0.5,{"alpha":1});
      }
      
      private function setInvisible(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      public function set handleClick(param1:Function) : void
      {
         if(this._handleClick != null)
         {
            removeEventListener(MouseEvent.CLICK,this._handleClick);
         }
         this._handleClick = param1;
         if(this._handleClick != null)
         {
            addEventListener(MouseEvent.CLICK,this._handleClick);
         }
      }
      
      public function get handleClick() : Function
      {
         return this._handleClick;
      }
      
      public function get typeVerbose() : String
      {
         return this._verboseTypes[this._type];
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get stdImage() : Bitmap
      {
         return this._stdImage;
      }
      
      public function set stdImage(param1:Bitmap) : void
      {
         this._stdImage = param1;
      }
      
      public function get hoverImage() : Bitmap
      {
         return this._hoverImage;
      }
      
      public function set hoverImage(param1:Bitmap) : void
      {
         this._hoverImage = param1;
      }
      
      public function get disabledImage() : Bitmap
      {
         return this._disabledImage;
      }
      
      public function set disabledImage(param1:Bitmap) : void
      {
         this._disabledImage = param1;
      }
      
      public function get state() : Boolean
      {
         return this._state;
      }
      
      public function set state(param1:Boolean) : void
      {
         this._state = param1;
      }
      
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
   }
}

