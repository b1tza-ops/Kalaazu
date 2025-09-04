package net.bigpoint.darkorbit.gui.container
{
   import com.bigpoint.utils.BPLocale;
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.catalog.SpecialAmmunition;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.data.vo.RankedHuntStatsVO;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.Ship;
   
   public class InfoContainer extends SimpleContainer
   {
      
      public function InfoContainer(param1:GuiManager, param2:int)
      {
         super(param1,param2);
      }
      
      public function setInfoField(param1:int, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < elements.length)
         {
            _loc4_ = elements[_loc3_];
            if(_loc4_ is InfoField)
            {
               if(InfoField(_loc4_).getID() == param1)
               {
                  InfoField(_loc4_).setText(param2);
               }
            }
            _loc3_++;
         }
      }
      
      public function updateInfoFieldView() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < elements.length)
         {
            _loc2_ = elements[_loc1_];
            if(_loc2_ is InfoField)
            {
               InfoField(_loc2_).updateView();
            }
            _loc1_++;
         }
      }
      
      public function updateInfoField(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RankedHuntStatsVO = null;
         var _loc5_:Object = null;
         var _loc6_:InfoField = null;
         var _loc7_:Map = null;
         var _loc8_:Ship = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:int = 0;
         var _loc31_:Bitmap = null;
         var _loc32_:Boolean = false;
         var _loc4_:int = 0;
         for(; _loc4_ < elements.length; _loc4_++)
         {
            _loc5_ = elements[_loc4_];
            if(!(_loc5_ is InfoField))
            {
               continue;
            }
            _loc6_ = _loc5_ as InfoField;
            if(_loc6_.getID() != param1)
            {
               continue;
            }
            switch(param1)
            {
               case SimpleElement.TYPE_LASER:
                  _loc10_ = Hero.maxLaserCapacity;
                  _loc11_ = 0;
                  for each(_loc9_ in Hero.laserBatteryAmounts)
                  {
                     _loc11_ += _loc9_;
                  }
                  _loc6_.setLabel(BPLocale.roundInteger(_loc11_));
                  _loc6_.setText(BPLocale.roundInteger(_loc11_) + InfoField.FIELD_SEPERATOR + BPLocale.roundInteger(_loc10_));
                  _loc6_.setCounterbar(_loc11_,_loc10_);
                  break;
               case SimpleElement.TYPE_ROCKETS:
                  _loc12_ = Hero.maxRocketCapacity;
                  _loc13_ = 0;
                  _loc13_ = Hero.rocketAmounts[RocketPattern.R310] + Hero.rocketAmounts[RocketPattern.PLT_2021] + Hero.rocketAmounts[RocketPattern.PLT_2026] + Hero.rocketAmounts[RocketPattern.PLT_3030] + Hero.rocketAmounts[RocketPattern.ECO10] + Hero.explosiveAmounts[SpecialAmmunition.MINE];
                  _loc6_.setLabel(BPLocale.roundInteger(_loc13_));
                  _loc6_.setText(BPLocale.roundInteger(_loc13_) + InfoField.FIELD_SEPERATOR + BPLocale.roundInteger(_loc12_));
                  _loc6_.setCounterbar(_loc13_,_loc12_);
                  break;
               case SimpleElement.TYPE_CONFIGURATION:
                  _loc14_ = Settings.selectedConfiguration;
                  _loc6_.setLabel(_loc14_.toString());
                  _loc6_.setText(_loc14_.toString(),false);
                  break;
               case SimpleElement.TYPE_HITPOINTS:
                  _loc7_ = guiManager.getMain().screenManager.map;
                  if(_loc7_ != null)
                  {
                     _loc8_ = _loc7_.getShipManager().getHero();
                     if(_loc8_ != null)
                     {
                        _loc23_ = _loc8_.getHitpoints();
                        _loc24_ = _loc8_.getMaxHitpoints();
                        _loc6_.setLabel(BPLocale.roundInteger(_loc23_));
                        _loc6_.setText(BPLocale.roundInteger(_loc23_) + InfoField.FIELD_SEPERATOR + BPLocale.roundInteger(_loc24_));
                        _loc6_.setCounterbar(_loc23_,_loc24_);
                        _loc25_ = 0;
                        if(_loc23_ > _loc24_)
                        {
                           _loc25_ = _loc23_ - _loc24_;
                           _loc6_.setCounterbarVisibility(1,true);
                           _loc6_.setCounterbar(_loc25_,_loc24_,true,1);
                        }
                        else
                        {
                           _loc6_.setCounterbarVisibility(1,false);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_SHIELD:
                  _loc7_ = guiManager.getMain().screenManager.map;
                  if(_loc7_ != null)
                  {
                     _loc8_ = _loc7_.getShipManager().getHero();
                     if(_loc8_ != null)
                     {
                        _loc26_ = _loc8_.getShield();
                        _loc27_ = _loc8_.getMaxShield();
                        _loc6_.setLabel(BPLocale.roundInteger(_loc26_));
                        _loc6_.setText(BPLocale.roundInteger(_loc26_) + InfoField.FIELD_SEPERATOR + BPLocale.roundInteger(_loc27_));
                        _loc6_.setCounterbar(_loc26_,_loc27_);
                     }
                  }
                  break;
               case SimpleElement.TYPE_CARGO:
                  _loc7_ = guiManager.getMain().screenManager.map;
                  if(_loc7_ != null)
                  {
                     _loc8_ = _loc7_.getShipManager().getHero();
                     if(_loc8_ != null)
                     {
                        _loc28_ = _loc8_.getCargo();
                        _loc29_ = _loc8_.getMaxCargo();
                        _loc6_.setLabel(BPLocale.roundInteger(_loc28_));
                        _loc6_.setText(BPLocale.roundInteger(_loc28_) + InfoField.FIELD_SEPERATOR + BPLocale.roundInteger(_loc29_));
                        _loc6_.setCounterbar(_loc28_,_loc29_);
                     }
                  }
                  break;
               case SimpleElement.TYPE_CREDITS:
                  _loc15_ = Hero.creditsAmount;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc15_));
                  _loc6_.setText(BPLocale.roundInteger(_loc15_));
                  break;
               case SimpleElement.TYPE_URIDIUM:
                  _loc16_ = Hero.uridiumAmount;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc16_));
                  _loc6_.setText(BPLocale.roundInteger(_loc16_));
                  break;
               case SimpleElement.TYPE_BOOTY_KEYS:
                  _loc17_ = Hero.bootyKeysAmount;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc17_));
                  _loc6_.setText(BPLocale.roundInteger(_loc17_),false);
                  break;
               case SimpleElement.TYPE_JUMP_VOUCHERS:
                  _loc18_ = Hero.jumpVouchersAmount;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc18_));
                  _loc6_.setText(BPLocale.roundInteger(_loc18_),false);
                  break;
               case SimpleElement.TYPE_JACKPOT:
                  _loc19_ = Hero.jackpotAmount;
                  _loc6_.setLabel(BPLocale.round(_loc19_,2));
                  _loc6_.setText(BPLocale.round(_loc19_,2));
                  break;
               case SimpleElement.TYPE_EXPERIENCE:
                  _loc20_ = Hero.experiencePoints;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc20_));
                  _loc6_.setText(BPLocale.roundInteger(_loc20_));
                  break;
               case SimpleElement.TYPE_HONOR:
                  _loc21_ = Hero.honorPoints;
                  _loc6_.setLabel(BPLocale.roundInteger(_loc21_));
                  _loc6_.setText(BPLocale.roundInteger(_loc21_));
                  break;
               case SimpleElement.TYPE_LEVEL:
                  _loc22_ = Hero.level;
                  _loc6_.setLabel(_loc22_.toString());
                  _loc6_.setText(_loc22_.toString(),false);
                  break;
               case SimpleElement.TYPE_RANKED_HUNT_POINTS:
                  _loc2_ = Hero.rankedHuntingEventData.currentID;
                  _loc3_ = Hero.rankedHuntingEventData.eventVOs[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc30_ = _loc3_.bountyPoints;
                     _loc6_.setLabel(BPLocale.roundInteger(_loc30_));
                     if(_loc3_.targetVerbose != null)
                     {
                        _loc6_.updateTooltip(BPLocale.getText(_loc6_.languageKey) + "\n" + _loc3_.targetVerbose);
                     }
                     if(_loc3_.targetList != null)
                     {
                        _loc31_ = ResourceManager.getBitmap("ui","npc" + _loc3_.targetList[0] + "icon");
                        if(_loc31_ != null)
                        {
                           _loc6_.updateIcon(_loc31_);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_CLAN_RANKED_CLAN_POINTS:
                  _loc2_ = Hero.rankedHuntingEventData.currentID;
                  _loc3_ = Hero.rankedHuntingEventData.eventVOs[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc32_ = true;
                     if(_loc3_.clanBountyPointsInSync)
                     {
                        _loc6_.setColor(15580416);
                        _loc32_ = false;
                     }
                     else
                     {
                        _loc6_.setColor(int(Styles.infoFieldFmt.color));
                        _loc32_ = _loc32_;
                     }
                     if(_loc32_)
                     {
                        _loc6_.setText(BPLocale.getText("ttip_clan_bounty_points_updated_in_5_minute_cycle"));
                     }
                     _loc6_.getChildByName("CLOCK_ICON").visible = _loc32_;
                     _loc6_.setLabel(BPLocale.roundInteger(_loc3_.clanBountyPoints));
                  }
                  break;
            }
         }
      }
   }
}

