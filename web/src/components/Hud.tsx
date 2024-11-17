import React from "react";
import { Badge, ThemeIcon } from "@mantine/core";
import { motion } from "framer-motion";
import {
  IconHeartbeat,
  IconRun,
  IconBurger,
  IconBottle,
  IconShield,
  IconSwimming,
  IconMicrophone,
} from "@tabler/icons-react";
import { config } from "./Config";

interface HudProps {
  visible: boolean;
  data: any;
}

const Hud: React.FC<HudProps> = ({ visible, data }) => {
  const hudItems = [
    { icon: <IconHeartbeat size={24} />, label: "Health", color: "red", value: data?.Health || 0 },
    { icon: <IconBottle size={24} />, label: "Thirst", color: "indigo", value: data?.Thirst || 0 },
    { icon: <IconBurger size={24} />, label: "Hunger", color: "orange", value: data?.Hunger || 0 },
    { icon: <IconRun size={24} />, label: "Stamina", color: "lime", value: data?.Stamina || 0 },
    {
      icon: <IconMicrophone size={24} />,
      label: "Microphone",
      color: data?.IsTalking ? "blue" : "gray",
      value: data?.IsTalking ? 100 : 0,
    },
    ...(data?.Armor > 0 ? [{ icon: <IconShield size={24} />, label: "Armor", color: "teal", value: data?.Armor }] : []),
    ...(data?.Oxygen > 0 ? [{ icon: <IconSwimming size={24} />, label: "Oxygen", color: "cyan", value: data?.Oxygen }] : []),
  ];

  let proximityPercentage = 0;

  if (data?.Prox <= 3) {
    proximityPercentage = 33;
  } else if (data?.Prox <= 7) {
    proximityPercentage = 66;
  } else if (data?.Prox <= 15) {
    proximityPercentage = 100;
  }

  const microphoneItem = hudItems.find((item) => item.label === "Microphone");
  if (microphoneItem) {
    microphoneItem.value = proximityPercentage;
  }

  return (
    <motion.div
      className={`hud ${visible ? "visible" : ""}`}
      initial={{ opacity: 0, y: 50 }}
      animate={visible ? { opacity: 1, y: 0 } : { opacity: 0, y: 50 }}
      exit={{ opacity: 0, y: 50 }}
    >
      <div style={{ display: "flex", marginLeft: "17px" }} className="hud-label">
        <Badge mt={5} size="md" variant={config.themeBadgeVariant} color="teal" radius="sm">
          {data?.Street}
        </Badge>
      </div>
      <div style={{ display: "flex", gap: "15px" }}>
        {hudItems.map((item, index) => (
          <motion.div
            className="hud-item"
            key={index}
            initial={{ opacity: 0, y: 50 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 50 }}
            transition={{ duration: 0.3, ease: "easeInOut" }}
          >
            <ThemeIcon
              size={45}
              variant={config.themeIconVariant}
              color={item.color}
              radius="md"
              className="icon"
            >
              {item.icon}
            </ThemeIcon>
            <div className="progress">
              <div
                className={`progress-bar ${item.color}`}
                style={{ width: `${item.value}%` }}
              />
            </div>
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
};

export default Hud;
