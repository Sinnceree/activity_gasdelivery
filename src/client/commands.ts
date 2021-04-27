import { formatEventName } from "../config/main"

RegisterCommand("startgas", async (source: number, args: string[]) => {
  TriggerEvent(formatEventName("attemptSignOnDuty"), source)
}, false)

RegisterCommand("stopgas", async (source: number, args: string[]) => {
  TriggerServerEvent(formatEventName("signOffDuty"), source)
}, false)

RegisterCommand("trailerfuel", async (source: number, args: string[]) => {
  TriggerServerEvent(formatEventName("getTrailerFuelLevel"))
}, false)

RegisterCommand("assign", async (source: number, args: string[]) => {
  TriggerServerEvent(formatEventName("assignGasStation"), GetPlayerServerId(source))
}, false)

RegisterCommand("trailerinteract", async (source: number, args: string[]) => {
  TriggerEvent(formatEventName("interaction"))
}, false)