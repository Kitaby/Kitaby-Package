import { Document, Types } from 'mongoose';
import mongoose from 'mongoose';
export type UserPayloadObject = {
  name: string
  email: string
}

export type MenuAsideItem = {
  label: string
  icon?: string
  href?: string
  target?: string
  color?: ColorButtonKey
  isLogout?: boolean
  menu?: MenuAsideItem[]
}

export type MenuNavBarItem = {
  label?: string
  icon?: string
  href?: string
  target?: string
  isDivider?: boolean
  isLogout?: boolean
  isDesktopNoLabel?: boolean
  isToggleLightDark?: boolean
  isCurrentUser?: boolean
  menu?: MenuNavBarItem[]
}

export type ColorKey = 'white' | 'light' | 'contrast' | 'success' | 'danger' | 'warning' | 'info'

export type ColorButtonKey =
  | 'white'
  | 'whiteDark'
  | 'lightDark'
  | 'contrast'
  | 'success'
  | 'danger'
  | 'warning'
  | 'info'
  | 'void'

export type BgKey = 'purplePink' | 'pinkRed'

export type TrendType = 'up' | 'down' | 'success' | 'danger' | 'warning' | 'info'

export type TransactionType = 'withdraw' | 'deposit' | 'invoice' | 'payment'

export type Transaction = {
  id: number
  amount: number
  account: string
  name: string
  date: string
  type: TransactionType
  business: string
}

export interface User extends Document{
  email: string;
  password: string;
  name: string;
  phone: string;
  categories: string[];
  verified: boolean;
  verifyLink?: string;
  ownedbooks?: string[];
  cart?: string[];
  wishlist?: string[];
  offers_received?: mongoose.Types.ObjectId[];
  offers_sent?: mongoose.Types.ObjectId[];
  photo?: string;
  wilaya?: string;
  createdAt?: String;
  banned?: boolean;
}
export interface Book extends Document {
  isbn: string;
  title: string;
  image: string;
  author: string;
  language?: string;
  description?: string;
  categories: string[];
  bibOwners?: {
    bib: mongoose.Types.ObjectId;
    quantity: number;
  }[];
  owners?: mongoose.Types.ObjectId[];
  numReservations?: number
  numExchanges?: number
}
export interface Offer extends Document {
  bookOwner: Types.ObjectId;
  bookBuyer?: Types.ObjectId;
  demandedBook: string;
  proposedBooks?: string[];
  status?: string;
}
export interface Bib extends Document{
  name: string;
  address?: string;
  wilaya?: string;
  openingHours?: string;
  avalaibleBooks?: mongoose.Types.ObjectId[];
  reservations?: mongoose.Types.ObjectId[];
  createdAt?: Date;
  updatedAt?: Date;
  com_reg_num?: string;
  phone?: string;
  admis?:boolean;
}

export interface Reservation extends Document {
  reserver: mongoose.Types.ObjectId;
  bib: mongoose.Types.ObjectId;
  isbn: string;
  date?: Date;
  status?: 'requested' | 'on hold' | 'expired' | 'reserved';
  createdAt?: Date;
  updatedAt?: Date;
}

export interface Report extends Document {
  description?: string[];
  modelName: string;
  reported: mongoose.Types.ObjectId;
  reporters?: mongoose.Types.ObjectId[];
  reports?: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export type UserForm = {
  name: string
  email: string
}
