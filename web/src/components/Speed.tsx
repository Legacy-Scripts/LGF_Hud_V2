import React from "react";
import { motion } from "framer-motion";
import { RingProgress, ThemeIcon } from "@mantine/core";
import { TbAutomaticGearbox } from "react-icons/tb";
import { PiEngine, PiTire } from "react-icons/pi";
import { BiSolidGasPump } from "react-icons/bi";
import { FaPowerOff } from "react-icons/fa";  
import { GaugeComponent } from 'react-gauge-component'; // https://github.com/antoniolago/react-gauge-component
import { config } from "./Config"; 

interface SpeedometerProps {
  visible: boolean;
  vehicleData: any;
}

const Speedometer: React.FC<SpeedometerProps> = ({ visible, vehicleData }) => {

  const speed = vehicleData?.Speed ? Math.min(vehicleData.Speed, 350) : 0;  
  const fuel = vehicleData?.Fuel ? Math.min(vehicleData.Fuel, 100) : 0;  
  const gear = vehicleData?.Gear || 0; 
  const engineHealth = vehicleData?.EngineHealth || 1000; 
  const tireHealth = vehicleData?.TireHealth || 1000
  const engineHealthColor = engineHealth > 600 ? 'indigo' : engineHealth > 300 ? 'orange' : 'red';
  const engineStatus = vehicleData?.EngineStatus;  
  const engineStatusColor = engineStatus === false ? 'red' : 'green';

  const hudItems = [
    {
      label: "Speed",
      style: {
        colorArray: ['rgba(9, 146, 104, 0.3)', 'rgba(224, 49, 49, 0.3)'],
        padding: 0.02,
        subArcs: [
          { limit: 40 },
          { limit: 60 },
          { limit: 70 },
          { limit: 100 },
          {} 
        ]
      },
      value: speed 
    },
    {
      icon: <BiSolidGasPump size={20}  />,
      label: "Fuel",
      color: "teal",
      value: fuel
    },
    {
      icon: <PiEngine size={20}  />,  
      label: "Engine Health",
      color: engineHealthColor,
      value: engineHealth
    },
    {
      icon: <FaPowerOff size={20}  />, 
      label: "Engine Status",
      color: engineStatusColor,
      value:engineStatus
    },
    {
      icon: <PiTire size={22} />,  
      label: "Tire Health",
      color: tireHealth > 800 ? 'violet' : tireHealth > 400 ? 'orange' : 'red',
      value: tireHealth
    },
    {
      icon: <TbAutomaticGearbox size={20} />,
      label: "Gear",
      color: "blue",
      value: gear
    },
  ];

  return (
    <motion.div
      className={`speed ${visible ? "visible" : ""}`}
      initial={{ opacity: 0, y: 50 }}
      animate={visible ? { opacity: 1, y: 0 } : { opacity: 0, y: 50 }}
      exit={{ opacity: 0, y: 50 }}
    >
      <div>
        <GaugeComponent
          type="semicircle"
          arc={hudItems[0].style }
          pointer={{ type: "blob", animationDelay: 0 }}
          value={speed} 
          maxValue={350} 
          labels={{
            valueLabel: {
              formatTextValue: (value: any) => `${value} KMH`,
              style: {
                fontSize: "40px", 
   
              }
            }
          }}
          style={{
            width: '300px', 
          }}
        />

        <div className="fuel">
          <RingProgress
            sections={[{ value: hudItems[1].value ?? 0, color: hudItems[1].color ?? "deepskyblue" }] }
            roundCaps
            size={60}
            thickness={4}
            label={
              <div className="center">
                {hudItems[1].icon}
              </div>
            }
          />
        </div>

        <div className="indicator">
          {hudItems.slice(2).map((item, index) => (
            <div key={index} className="indicator-item">
              <ThemeIcon
                size={38}
                variant={config.themeIconVariant}
                color={item.color}
                radius="md"
                className="icon"
              >
                {item.icon}
              </ThemeIcon>

              {item.label === "Gear" && (
                <span style={{ marginLeft: '10px', color: 'white', fontSize: '20px' }}>
                  {item.value}
                </span>
              )}
            </div>
          ))}
        </div>
      </div>
    </motion.div>
  );
};

export default Speedometer;
