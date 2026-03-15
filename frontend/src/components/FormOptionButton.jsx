import "./form-option-button.css";

function joinClasses(...values) {
  return values.filter(Boolean).join(" ");
}

export function FormOptionButton({
  title,
  description,
  selected = false,
  onClick,
  type = "button",
  align = "left",
  density = "regular",
  radius = "soft",
  disabled = false,
  className = ""
}) {
  return (
    <button
      type={type}
      className={joinClasses(
        "form-option-button",
        selected && "is-selected",
        density === "compact" && "is-compact",
        radius === "square" && "is-square",
        radius === "rounded" && "is-rounded",
        radius === "pill" && "is-pill",
        align === "center" && "is-center",
        className
      )}
      onClick={onClick}
      disabled={disabled}
    >
      <strong className="form-option-button__title">{title}</strong>
      {description ? (
        <p className="form-option-button__description">{description}</p>
      ) : null}
    </button>
  );
}